#include <stdio.h>
#include "y.tab.h"

extern int yylex();
extern int yylineno();
extern char* yytext;


char* name[] = {NULL,"Integer","Double colon","Left parenthesis","Right parenthesis","Open bracket","Close bracket","Identifier","Keyword","Colon" };

int main(void)
{

    int ntoken, vtoken;

    ntoken = yylex();

    while(ntoken) {

        printf("%d\n",ntoken);

        ntoken = yylex();

       }


}
