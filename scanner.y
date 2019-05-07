%{
void yyerror (char const *s);
int yylex();
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include<string.h>
#include "sytable.c"
char globalName[50] = "Global";
char ifBlock[100] = "if";
int ifCounter = 35;
struct Scope * prevScope = NULL;
struct symbolTable s1;
struct Node *tempNodeArray[NMAX];
struct Node * tempNode;
extern int yylineno;
int savedValue;
char savedID[100];
char savedType[50];


//Abstract Syntax Tree
struct abstractNode {

	char varName[50];
	struct abstractNode * left;
	struct abstractNode * right;

};

struct abstractNode *  makeAbstractNode(struct abstractNode * left, char name[50], struct abstractNode * right);
struct abstractNode* tPtr;
struct abstractNode* fPtr;
struct abstractNode* sPtr;

%}

%define parse.error verbose

%union 	{
	int iVal;
	float fVal;
	char *sVal;
}

%type <sVal> ID
%type <iVal> NUM
%type <sVal> INT

%token INT FLOAT CHAR DOUBLE VOID
%token IF ELSEIF ELSE
%token NUM
%token ID
%token AND OR NOT
%token DOUBLECOLON
%token WHILE

%right ':'
%left OR
%left AND
%left LE GE EQ NE LT GT /*<=, >=, ==, !=, <. >*/
%right NOT


%%
start: External_Declaration {printf("end\n");}

External_Declaration: External_Declaration Declaration
                    | External_Declaration Function  {


 if(scopeLookup(globalName, &s1) == -1) {

  struct Scope * scope = scopeInsert(globalName, &s1);
  prevScope->parent = scope;
  printf("III\n");


 }
 else {
 prevScope->parent = s1.scopeArray[hashFunction(globalName,SMAX)];

 }



}
                    | /*Empty Space*/

/* Declaration block */
Declaration: Type Assignment
           | Assignment
           ;

/*<Function block*/

Function : Type DOUBLECOLON ID '('ArgListOpt')' CompoundStatement {
	if(scopeLookup($3,&s1) == -1){
    struct Scope * scope = scopeInsert($3, &s1);

		if(prevScope != NULL)
					prevScope->parent = scope;


		scope->nodeArray = tempNodeArray[NMAX];

    prevScope = scope;

    }
    else printf("Error: function %s is already declared\n",$3);

}

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

StatementList: Statement StatementList
             | /*Empty Scpace*/
             ;

Statement: Declaration {printf("Declaration\n");
			printf("%s\n",savedID);
			printf("%s\n",savedType);

			int lookUpresult = nodeLookup(savedID, tempNodeArray);

			if(lookUpresult == -1) {

						tempNode = nodeInsert(savedID,savedType);
						insertIntoNodeArray(tempNode, tempNodeArray);
			 }
		else if(strcmp(savedType,"") == 0 && lookUpresult == 0 ) {
					 printf("Already stored\n");
			}
			else  printf("Error! Variable %s already declared\n", savedID);

			memset(savedID,'\0',sizeof(savedID));
			memset(savedType,'\0',sizeof(savedType));


		}
         | IfBlockStatements
         | WhileStatement
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


/*<While Statement*/

WhileStatement: WHILE '(' Expression ')' '{' StatementList '}'


/*>While Statement*/

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

Assignment: ID ':' Assignment { strcpy(savedID,$1);
 	printf("line no %d\n",yylineno);}
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
Type:  INT { strcpy(savedType,$1); }
   | FLOAT
   | CHAR
   | DOUBLE
   |VOID
   ;



%%

struct abstractNode *  makeAbstractNode(struct abstractNode * left, char name[50], struct abstractNode * right) {

			struct abstractNode * node = (struct abstractNode *)malloc(sizeof(struct abstractNode));
			strcpy(node->varName,name);
			node->left = left;
			node->right = right;
			return node;
}


int main (void) {
  printf("Saad Salman\n");
	intializeNodeArray(tempNodeArray);
  intializeScope(&s1);

	return yyparse ( );



}

void yyerror (char const *s) {fprintf (stderr, "%s\n", s);}
