%option noyywrap

%{
%}

%%
^[ \t]*         {}
^[ \t]*\n       {}
^[ \t]*#.*\n    {}
.|\n            { fprintf(yyout, "%s", yytext); }
%%

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

    fprintf(yyout, "#!/bin/bash\n");

    for(i = 2; i < argc; i++) {
        yyin = fopen(argv[i], "r");
        if(!yyin) {
            perror("fopen error: ");
            return -1;
        }
        yyrestart(yyin);
        yylex();
    }

    return 0;
}

