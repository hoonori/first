calc.exe : lex.yy.c main.c my.tab.c
	gcc -o calc.exe my.tab.c lex.yy.c main.c
lex.yy.c: my.l
	flex my.l
my.tab.c: my.y
	bison -d my.y

clean:
	rm calc.exe lex.yy.c my.tab.c my.tab.h
