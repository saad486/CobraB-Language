%{

#include "y.tab.h"
%}

%option yylineno
%%
int  { yylval.sVal = strdup(yytext); return INT; }
float return FLOAT;
char return CHAR;
void return VOID;
double return DOUBLE;
if return IF;
elseif return ELSEIF;
else return ELSE;
while return WHILE;
[a-zA-Z][_a-zA-Z0-9]* { yylval.sVal = strdup(yytext); return ID; }
[1-9][0-9]* { yylval.iVal = atoi(yytext); return NUM; }
"::" return DOUBLECOLON;
"<" return LT;
">" return GT;
">=" return GE;
"<=" return LE;
"==" return EQ;
"!=" return NE;
"&&" return AND;
"||" return OR;
"!" return NOT;
[ \t\n]+ ;
.   return yytext[0];
%%

int yywrap(void)
{
    //yylex();
    return 1;
}
