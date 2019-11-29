proj3 : lex.yy.c my.tab.c
	gcc -o proj3 my.tab.c lex.yy.c
lex.yy.c: my.l
	flex my.l
my.tab.c: my.y
	bison -d my.y

clean:
	rm proj3 lex.yy.c my.tab.c my.tab.h
