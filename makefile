scanner: y.tab.c lex.yy.c
	gcc -o scanner lex.yy.c y.tab.c 

lex.yy.c: y.tab.c scanner.l
	lex scanner.l

y.tab.c: scanner.y
	yacc -d -v scanner.y 

