/* Definition section */
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	int externalLine(char *c);
	int countLine;
	int commentLine;
	int var;
	int fail;

	/* Symbol table function */
	void create_symbol();
	void insert_symbol();
	int lookup_symbol();
	void dump_symbol();

%}

/* Define regular expression label */

letter [a-zA-Z]
digit [0-9]
id {letter}+({letter}|{digit})*
number {digit}+
frac {number}+"."+{number}
assign [=]
compare [<]|[>]
function "for"|"println"|"if"
type "int"|"float32"
/*c++ type comment*/
comment1 "//"+({letter}|{digit}|" "|.)*		
/*c type comment*/
comment2 "/*"+({letter}|{digit}|" "|"\n"|.)*+"*/"
undefined ";"|" "

/* Rules section */
%%

{undefined} {;}
{type}  {printf("%s\t DATATYPE : %s\n", yytext, yytext);if (!fail)insert_symbol(yytext,1);}
{function}		{printf("%s\t FUNTION : %s \n", yytext, yytext);}
{compare} 	{printf("%s \t COMPARE \n", yytext);}
{assign} 	{ printf("%s \t ASSIGN \n", yytext); }
"("		{ printf("%s \t LB \n", yytext); }
")"		{ printf("%s \t RB \n", yytext); }
"{"		{ printf("%s \t LCB \n", yytext); }
"}"		{ printf("%s \t RCB \n", yytext); }
"+" 	{ printf("%s \t Add \n", yytext); }
"-"		{ printf("%s \t Sub \n", yytext); }
"*"		{ printf("%s \t Mul \n", yytext); }
"/"		{ printf("%s \t Div \n", yytext); }
"%"		{ printf("%s \t Mod \n", yytext); }
"++"	{ printf("%s \t INCRECEMENT \n", yytext); }
"--"	{ printf("%s \t DECRECEMENT \n", yytext); }
"var"   {var=1;}
\n		{countLine++;}
{id}	{ printf("%s \t ID \n", yytext); 
	if(!lookup_symbol(yytext) && var)insert_symbol(yytext,0);	/*insert*/
	else if (lookup_symbol(yytext) && var) {printf("redefined variable : %s\n",yytext);fail=1;}	/*redefined*/
	else if (!lookup_symbol(yytext) && !var) {printf("undefined variable : %s\n",yytext);fail=1;}	/*undefined*/
	else;	/*normal*/

	var=0;
	}


{number} { printf("%s \t NUMBER \n", yytext); }
{frac} { printf("%s \t FRAC \n", yytext); }
{comment1} {printf("%s \t C++ COMMENT \n", yytext);commentLine++;}
{comment2} {printf("%s \t C type COMMENT \n", yytext);commentLine++;countLine+=externalLine(yytext);}
. {;}
%%

/*	C Code section */
int yywrap(void)
{
    return 1;
}


/* define symbol table */
struct SymbolTable {
	int index;
	char type[12];
	char name[12];
};
struct SymbolTable sym[1000];	/*max num of variale 1000*/

int countLine;
int commentLine;
int countIndex;
int var;
int fail;

/* count number of '\n' in C type comment */
int externalLine(char *c) {
	int current=0;
	int countNewLine=0;

	while (c[current]!='\0') {
		if (c[current]=='\n')
			countNewLine++;
		current++;
	}

	commentLine+=countNewLine;
	return countNewLine;
}

void create_symbol() {
	printf("create symbol table\n\n");
}

void insert_symbol(char *s, int mode) {
	if (!mode) { /* ID */	
		printf("Insert : %s\n", s);
		strcpy(sym[countIndex].name,s);
	}
	else { /* TYPE */
		strcpy(sym[countIndex].type,s);
		countIndex++;
	}
}

int lookup_symbol(char *s) {
	
	int current=0;

	while (current <= countIndex) {
		if (!strcmp(s,sym[current].name)) 
			return 1;	/* found */
		current++;
	}
	return 0; /* not found */
}

void dump_symbol() {
	printf("\nIndex\tId\tType\n");

	int current=0;
	while (current<countIndex) {
		printf("%d\t%s\t%s\n", current,sym[current].name,sym[current].type);
		current++;
	}
}

int main(int argc,char *argv[])
{
	countLine=0;
	commentLine=0;
	var=0;
	fail=0;

	/* create symbol table */
	countIndex=0;
	create_symbol();

	yyin = fopen(argv[1],"r");
	yylex();

	printf("\ncode %d lines\n", countLine);
	printf("comment %d lines\n", commentLine);

	dump_symbol();

	return 0;
}