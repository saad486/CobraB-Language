%{
void yyerror (char const *s);
int yylex();
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
int symbol[52]; //Symbol table
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
%}

%define parse.error verbose

%token INT FLOAT CHAR DOUBLE VOID
%token IF ELSEIF ELSE
%token NUM 
%token ID
%token AND OR NOT
%token DOUBLECOLON

%right ':'
%left OR
%left AND
%left LE GE EQ NE LT GT /*<=, >=, ==, !=, <. >*/
%right NOT

%%
start: External_Declaration

External_Declaration: External_Declaration Declaration
                    | External_Declaration Function
                    | /*Empty Space*/

/* Declaration block */
Declaration: Type Assignment 
           | Assignment
           ;

/*<Function block*/

Function : Type DOUBLECOLON ID '('ArgListOpt')' CompoundStatement 

/*< Function argument block*/

ArgListOpt : ArgList
           | /*Empty Space*/

ArgList : ArgList ',' Arg
        | Arg
        ;

Arg : Type ID
    ;
/*> Function argument block*/

/*< Compound Statement block*/

CompoundStatement: '{'StatementList'}'
                 ;

StatementList: StatementList Statement
             | /*Empty Scpace*/
             ;

Statement: Declaration
         | IfBlockStatements
         ;

/*<If statement*/

IfBlockStatements: IfStatement ElseIfStatement ElseStatement

IfStatement: IF '(' Expression ')''{' StatementList '}'
           ;

ElseIfStatement: ELSEIF '(' Expression ')''{' StatementList '}'
               |/*Empty Space*/
               ;

ElseStatement: ELSE '{' StatementList '}'
             |/*Empty Space*/
             ;

/*>If statemet*/


Expression: Expression LE Expression
          | Expression GE Expression
          | Expression NE Expression
          | Expression EQ Expression
          | Expression GT Expression
          | Expression LT Expression
          | Expression OR Expression
          | Expression AND Expression
          | NOT Expression
          | ID
          | NUM
          ;


/*> Compound Statement block */

Assignment: ID ':' Assignment  
          | ID '+' Assignment   
          | ID '-' Assignment     
          | ID '*' Assignment
          | ID '/' Assignment
          | NUM '+' Assignment
          | NUM '-' Assignment
          | NUM '*' Assignment
          | NUM '/' Assignment 
          |   NUM  
          |   ID
          ;

/* Type identifier block */
Type:  INT  
   | FLOAT
   | CHAR
   | DOUBLE
   |VOID
   ; 



%%

int main (void) {
  printf("Saad Salman\n");
  
	return yyparse ( );

}

void yyerror (char const *s) {fprintf (stderr, "%s\n", s);}
