%option noyywrap

%x MAKEFILE
%x MK_LCOMMENT
%x MK_VARIBLE_OP
%X MK_VARIBLE_VALUE

%{
/**
 * %x define a start state
 * %x MAKEFILE		makefile start state
 * %x MK_LCOMMENT	makefile line comment start state
 * %x MK_VARIBLE_OP	makefile varible operation start state
 * %x MK_VARIBLE_VALUE	makefile varible value start state
 */

#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <errno.h>

#include <unistd.h>
#include <fcntl.h>

#include <sys/queue.h>

struct inpfile_desc {
	YY_BUFFER_STATE	bs;
	FILE	*fp;
};

enum evar {
	VARIBLE_NAME = 0,
	VARIBLE_OP,
	VARIBLE_VALUE,
	VARIBLE_END
};

struct var_desc {
	//CIRCLEQ_HEAD(, cbuffer)
	//	comment_head;
	char	name[64];
	char	op[8];
	char	value[512];

	CIRCLEQ_ENTRY(var_desc)
		list;
};

struct {
	CIRCLEQ_HEAD(, var_desc) qhead;
	struct var_desc *cur;
} g_queue;

int end_of_file(void);
void read_lcomment_string(char *text);
void read_varible_string(enum evar e, char *text);

%}

%%
^"# makefile"[ \t]*\n	{
	/* filetype is makefile */
	BEGIN MAKEFILE;
}

<MAKEFILE>^[ \t]*"#"	{ BEGIN MK_LCOMMENT; /* line comment */ }

<MAKEFILE>^[_a-zA-Z][_a-zA-Z0-9]*	{
	/* a varible */
	read_varible_string(VARIBLE_NAME, yytext);
	BEGIN MK_VARIBLE_OP;
}

<MAKEFILE>^[ \t]*\n	{ /* space line, do nothing */ }
<MAKEFILE>^export.*\n	{ /* export line, do nothing */}

<MAKEFILE><<EOF>>	{
	end_of_file(); /* end of file */
	yyterminate(); /* terminate */
}

<MK_LCOMMENT>.*		{
	/* malloc a buffer to read the line comment */
	read_lcomment_string(yytext);
}
<MK_LCOMMENT>\n		{ BEGIN MAKEFILE; }

<MK_VARIBLE_OP>[ \t]*	{ /* discard */ }
<MK_VARIBLE_OP>[\?:]?=	{
	read_varible_string(VARIBLE_OP, yytext);
	BEGIN MK_VARIBLE_VALUE;
}
<MK_VARIBLE_OP>.	{
	fprintf(yyout, "MK_VARIBLE_OP unhandle 0x%x(%c)\n", *yytext, *yytext);
}
<MK_VARIBLE_OP>\n	{
	read_varible_string(VARIBLE_VALUE, "");
	BEGIN MAKEFILE;
}

<MK_VARIBLE_VALUE>[ \t]*	{ /* discard */ }
<MK_VARIBLE_VALUE>[^ \t\n].*	{
	read_varible_string(VARIBLE_VALUE, yytext);
}
<MK_VARIBLE_VALUE>\n	{ BEGIN MAKEFILE; }

<MAKEFILE>.|\n		{ /* nothing */ }

.|\n	{ /* nothing */ }

%%

void yyerror(char *msg, ...)
{
	va_list vl;
	va_start(vl, msg);
	vprintf(msg, vl);
	va_end(vl);
}

int end_of_file(void)
{
	return 0;
}

void read_lcomment_string(char *text)
{
}

static struct var_desc * q_varible_find(char *name)
{
	struct var_desc *p;

	for(p = g_queue.qhead.cqh_first; p != (void *)&g_queue.qhead;
			p = p->list.cqe_next) {
		if(strcmp(name, p->name) == 0)
			return p;
	}

	return NULL;
}

static struct var_desc * q_varible_insert(char *name)
{
	struct var_desc *var;

	var = q_varible_find(name);
	if(var)
		return var;

	var = malloc(sizeof(*var));
	if(!var) {
		printf("%s, nomem\n", __func__);
	} else {
		strcpy(var->name, name);
		*var->op = 0;
		*var->value = 0;
		CIRCLEQ_INSERT_TAIL(&g_queue.qhead, var, list);
	}

	return var;
}

static int varible_assign_value(char *value)
{
	if(!g_queue.cur)
		return -1;

	switch(*g_queue.cur->op) {
	case '?':
		if(!(*g_queue.cur->value))
			strcpy(g_queue.cur->value, value);
		break;
	case ':':
	case '=':
		strcpy(g_queue.cur->value, value);
		break;
	default:
		yyerror("unknown op (%s)\n", g_queue.cur->op);
		break;
	}
}

void read_varible_string(enum evar e, char *text)
{
	switch(e) {
	case VARIBLE_NAME:
		g_queue.cur = q_varible_insert(text);
		break;
	case VARIBLE_OP:
		if(g_queue.cur)
			strcpy(g_queue.cur->op, text);
		break;
	case VARIBLE_VALUE:
		varible_assign_value(text);
		break;
	default:
		fprintf(yyout, " %s error\n", __func__);
		break;
	}
}

void circleq_free(void)
{
}

int load_file(char *filename)
{
	struct inpfile_desc inpfile;

	inpfile.fp = fopen(filename, "r");
	if(!inpfile.fp) {
		yyerror("%s fopen %s fail: %s\n", __func__, filename, strerror(errno));
		return -1;
	}

	inpfile.bs = yy_create_buffer(inpfile.fp, YY_BUF_SIZE);
	if(!inpfile.bs) {
		yyerror("yy_create_buffer fail\n");
		fclose(inpfile.fp);
		return -1;
	}

	yy_switch_to_buffer(inpfile.bs);

	yyrestart(yyin);
	yylex();

	yy_delete_buffer(inpfile.bs);

	fclose(inpfile.fp);
}

int create_makeconfig(char *outfile)
{
	const char *header = "# makefile\n\n";
	char buf[1024];
	int fd;
	struct var_desc *p;
	int rc;

	fd = open(outfile, O_RDWR | O_CREAT | O_TRUNC, 0666);
	if(fd < 0) {
		printf("%s open %s fail, %s\n", __func__, buf, strerror(errno));
		return fd;
	}

	rc = write(fd, header, strlen(header));

	for(p = g_queue.qhead.cqh_first; p != (void *)&g_queue.qhead;
			p = p->list.cqe_next) {
		rc = sprintf(buf, "%s %s %s\n\n", p->name, p->op, p->value);
		if(rc > 0)
			rc = write(fd, buf, rc);
#if 0
		rc = sprintf(buf, "export %s\n\n", p->name);
		if(rc > 0)
			rc = write(fd, buf, rc);
#endif
	}

	close(fd);
}

int create_shconfig_makefile(char *outfile)
{
	const char *header = ""
		"$(dest_out):$(src_in)\n"
		"\t@echo 'out = $(dest_out), in = $(src_in)'\n"
		"\t@echo '#!/bin/bash' > $@\n"
		"\t@echo '# do not edit this auto created file' >> $@\n";
	char buf[1024];
	int fd;
	struct var_desc *p;
	int rc;

	fd = open(outfile, O_RDWR | O_CREAT | O_TRUNC, 0666);
	if(fd < 0) {
		printf("%s open %s fail, %s\n", __func__, buf, strerror(errno));
		return fd;
	}

	rc = write(fd, header, strlen(header));

	for(p = g_queue.qhead.cqh_first; p != (void *)&g_queue.qhead;
			p = p->list.cqe_next) {
		rc = sprintf(buf, "\t@echo '%s=$(%s)' >> $@\n", p->name, p->name);
		if(rc > 0)
			rc = write(fd, buf, rc);
	}

	close(fd);

}

int main(int argc, char *argv[])
{
	int i;
	char *build_option;
	char *outfile;

	if(argc < 4) {
		printf("usage: %s [mkconfig(default)|shconfigmk] outfile src_file ..\n", argv[0]);
		return -1;
	}

	g_queue.cur = NULL;
	CIRCLEQ_INIT(&g_queue.qhead);

	for(i = 3; i < argc; i++)
		load_file(argv[i]);

	build_option = argv[1];
	outfile = argv[2];

	if(strcmp(build_option, "shconfigmk") == 0)
		create_shconfig_makefile(outfile);
	else
		create_makeconfig(outfile);

	circleq_free();

	return 0;
}

