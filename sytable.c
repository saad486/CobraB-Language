#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define SMAX  51
#define NMAX  31

//=========================================
struct Node {

	char nodeName[50];
	char type[50];
	struct Node * next;
};

struct Scope {

	struct Node * nodeArray;
	char scopeName[50];
	struct Scope * next;
	struct Scope* parent;
};

struct symbolTable {

	struct Scope * scopeArray[SMAX];

};


//===================================================
void intializeScope(struct symbolTable * s1);
void intializeNodeArray(struct Node * n[]);
//================================================

int  hashFunction(char name[], int divide);
struct Scope * scopeInsert(char scopeName[], struct symbolTable * sym);
struct Node * nodeInsert(char nodeName[],char typeName[]);
void insertIntoNodeArray(struct Node * node, struct Node * nodeArray[]);
int scopeLookup(char scopeName[], struct symbolTable * sym);
int nodeLookup(char varName[],struct Node * nodeArray[]);
//=========================================

//
// int main() {
//
// 	//Scope
// 	struct symbolTable s1;
//
// 	intializeScope(&s1);
//
//
// 	char* scopeName = "Global";
//
// 	struct Scope * scope = scopeInsert(scopeName, &s1);
// 	intializeNode(scope);
// 	nodeInsert("a","int",scope);
// 	nodeInsert("a","int",scope);
// }

struct Scope * scopeInsert(char scopeName[], struct symbolTable * sym) {

	int hashNumber = hashFunction(scopeName,SMAX);
	struct Scope * assignScope = (struct Scope *)malloc(sizeof(struct Scope));
	strcpy(assignScope->scopeName, scopeName);
	assignScope->next = NULL;
	assignScope->parent = NULL;


	if (sym->scopeArray[hashNumber] == NULL) {

		sym->scopeArray[hashNumber] = assignScope;

	}
	else {

		struct Scope * start = sym->scopeArray[hashNumber];
		while (start->next != NULL ) {
			start = start->next;
		}

		start->next = assignScope;


	}
	return assignScope;

}

struct Node * nodeInsert(char nodeName[],char typeName[]){

	int hashNumber = hashFunction(nodeName,NMAX);
	struct Node * assignNode = (struct Node *)malloc(sizeof(struct Node));
	strcpy(assignNode->nodeName, nodeName);
	strcpy(assignNode->type, typeName);
	assignNode->next = NULL;
	return assignNode;

}

void insertIntoNodeArray(struct Node * node, struct Node * nodeArray[]) {

		int hashNumber = hashFunction(node->nodeName, NMAX);

		if(nodeArray[hashNumber] == NULL) {

			nodeArray[hashNumber] = node;
		}
		else {

					struct Node * start = nodeArray[hashNumber];

					while(start->next != NULL) {

							start = start->next;
					}
						start->next = node;

		}


}

int scopeLookup(char scopeName[], struct symbolTable * sym) {

		int hashNumber = hashFunction(scopeName, SMAX);

		if(sym->scopeArray[hashNumber] == NULL){
					return -1;
		}
		else {

			struct Scope * start = sym->scopeArray[hashNumber];
			while (start->next != NULL || strcmp(scopeName, start->scopeName) != 0) {
				start = start->next;
			}

			if(strcmp(scopeName, start->scopeName) == 0) {
				return 0;
			}
			else return -1;

		}

}
int nodeLookup(char varName[], struct Node * nodeArray[]) {

		int hashNumber = hashFunction(varName, NMAX);

		if (nodeArray[hashNumber] == NULL) {
				return -1;
		}
		else {

				struct Node * start = nodeArray[hashNumber];
				while(start->next != NULL || strcmp(varName, start->nodeName) != 0) {
						start = start->next;
				}

				if(strcmp(varName, start->nodeName) == 0) {
							return 0;
				}
				else return -1;

		}

}

/*void updateValue(char savedID[], int savedValue,struct Node * nodeArray[]) {

		int hashNumber = hashFunction(savedID, NMAX);

		if (nodeArray[hashNumber] != NULL && strcmp(savedID,nodeArray[hashNumber]->nodeName)==0) {

				nodeArray[hashNumber]->value = savedValue;
		}
		else {

				struct Node * start = nodeArray[hashNumber];
				while(start->next != NULL || strcmp(savedID, start->nodeName) != 0) {
						start = start->next;
				}
				if(strcmp(savedID, start->nodeName) == 0) {
						start->value = savedValue;
				}
		}

}*/
int hashFunction(char name[], int divide) {

	int asciiSum = 0;

    for (int i = 0; i < strlen(name); i++) {
        asciiSum = asciiSum + name[i];
    }
    asciiSum = asciiSum*117/17;

    return (asciiSum % divide);
}

void intializeScope(struct symbolTable * s1) {

	for(int i = 0; i<SMAX; i++)
		s1->scopeArray[i] = NULL;

}

void intializeNodeArray(struct Node * n[]) {

	for(int i = 0; i<NMAX; i++)
				n[i] = NULL;
}
