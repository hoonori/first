%{
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "my.tab.h"


int yylineno;
extern YYSTYPE yylval;

struct Node{
    struct Node* next;
    char* name;
    double value;
    int flag;
};

struct Node* searchfor(char* Nname);
struct Node* makenew(char* Nname);
extern struct Node* head;


%}
%%

"+" { return PLUS; }
"-" { return MINUS; }
"*" { return MULT; }
"/" { return DIV; }
";" { return SEMICOLON; }
"!" { return NEGATE; }
"(" { return OPENPAR;}
")" { return CLOSEPAR;}
"!=" { return NOTEQUAL;}
"==" { return EQUAL;}
">=" { return GREQ;}
"<=" { return LSEQ;}
">" {return GREATER;}
"<" {return LESSER;}
"SET" {return SET;}
"to" {return TO;}
"PRINT" {return PRINT;}
"IF" {return IF;}
"THEN" {return THEN;}
"ELSE" {return ELSE;}
"ENDIF" {return ENDIF;}
"WHILE" {return WHILE;}
"DO"    {return DO;}
"ENDWHILE" {return ENDWHILE;}

[a-zA-Z]+ {
    char* new = malloc( sizeof(char) * (strlen(yytext) + 1) );
    strcpy (new,yytext);
    yylval.NAME = new;
    return ID;
}

[0-9]+("."[0-9]+)? {
    double answer = 0;
    char* pointer = yytext;
    
    while (*pointer != '\0' && *pointer != '.'){
        char cur = *pointer;
        answer *= 10;
        answer += (double)(cur - '0');
        pointer++;
    }

    if (*pointer == '.'){
        double bias = 0.1;
        pointer++;
        while (*pointer != '\0'){
            char cur = *pointer;
            answer += (double)(cur - '0') * bias;
            bias *= 0.1;
            pointer++;
        }
    }
    yylval.DOUBLE = answer;
    return NUMBER;

}
"\n" {++yylineno;}
[ \t\r]+ { }
.   {}
%%
int yywrap(){
    return 1;
}

