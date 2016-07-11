%option noyywrap

%x SHELL_SCRIPT
%x IFILE
%x COMMENT

%x PYTHON_SCRIPT
%x PS_LCOMMENT
%x PS_MCOMMENT

%{
struct ifile_desc {
    struct ifile_desc *prev;
    YY_BUFFER_STATE bs;
    FILE *fp;
};

struct ifile_desc *cur;
%}

%%
^"#!/bin/bash"[ \t]*\n	{
	/* parse bash shell script */
	fprintf(yyout, "#!/bin/bash\n");
	BEGIN SHELL_SCRIPT;
}

^"#!/usr/bin/env python"[ \t]*\n	{
	/* parse python script */
	fprintf(yyout, "#!/usr/bin/env python\n");
	BEGIN PYTHON_SCRIPT;
}

<SHELL_SCRIPT>^"#include"[ \t]*\"	{ BEGIN IFILE; /* do include */}

<SHELL_SCRIPT>^[ \t]*"#"		{ BEGIN COMMENT; /* do comment */ }

<SHELL_SCRIPT><<EOF>>	{ if(popfile() != 0) yyterminate(); /* file eof */ }

<SHELL_SCRIPT>^[ \t]*	{ /* nothing */ }

<SHELL_SCRIPT>^[ \t]*\n	{ /* nothing */ }

<SHELL_SCRIPT>.|\n	{ fprintf(yyout, "%s", yytext); /* copy */ }

<IFILE>[^ \t\"]*        {
    { int c; while((c = input()) && c != '\n'); }   // clear tail
    if(newfile(yytext) < 0) yyterminate();
    BEGIN SHELL_SCRIPT;
}

<IFILE>.|\n     { yyerror("include file name error!"); }

<COMMENT>.      {}

<COMMENT>\n     { BEGIN SHELL_SCRIPT; }

<PYTHON_SCRIPT>^[ \t]*"#"	{ BEGIN PS_LCOMMENT; }

<PYTHON_SCRIPT>^[ \t]*\"\"\"	{ BEGIN PS_MCOMMENT; }

<PYTHON_SCRIPT><<EOF>>		{ if(popfile() != 0) yyterminate(); /* file eof */ }

<PYTHON_SCRIPT>^[ \t]*\n	{ /* nothing */ }

<PYTHON_SCRIPT>.|\n	{ fprintf(yyout, "%s", yytext); /* copy */ }

<PS_LCOMMENT>.		{ /* nothing */ }

<PS_LCOMMENT>\n		{ BEGIN PYTHON_SCRIPT; }

<PS_MCOMMENT>\"\"\"[ \t]*\n	{ BEGIN PYTHON_SCRIPT; }

<PS_MCOMMENT>.		{ /* nothing */ }

%%

yyerror(char *msg)
{
    printf("yyerror: %s", msg);
}

int newfile(char *fn)
{
    struct ifile_desc *p;

    p = malloc(sizeof(*p));
    if(!p) {
        yyerror("newfile malloc failed.\n");
        return -1;
    }

    p->fp = fopen(fn, "r");
    if(!p->fp) {
        yyerror("newfile fopen failed.\n");
        return -1;
    }

    p->bs = yy_create_buffer(p->fp, YY_BUF_SIZE);
    if(!p->bs) {
        yyerror("newfile create buffer failed.\n");
        fclose(p->fp);
        return -1;
    }

    p->prev = cur;

    cur = p;

    yy_switch_to_buffer(cur->bs);
    return 0;
}

int popfile(void)
{
    struct ifile_desc *p;

    if(!cur)
        return -1;

    p = cur;

    fclose(p->fp);
    yy_delete_buffer(p->bs);

    if(!p->prev) {
        cur = NULL;
        free(p);
        return 1;
    }

    cur = p->prev;
    free(p);

    yy_switch_to_buffer(cur->bs);
    return 0;
}

/**
 * usage:
 * build out_filename in_filename
 */
int main(int argc, char *argv[])
{
    int i;

    if(argc < 3) {
        printf("require in & out file\n");
        return -1;
    }

    yyout = fopen(argv[1], "w+");
    if(!yyout) {
        perror("fopen out error: ");
        return -1;
    }

    for(i = 2; i < argc; i++) {
        if(newfile(argv[i]) < 0)
            yyterminate();
        yyrestart(yyin);
        yylex();
    }

    return 0;
}

