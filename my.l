%{
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "my.tab.h"
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
[a-zA-Z]+ {
    
    yylval.NODEP = searchfor(yytext);
    
    return VARIABLE;
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
"+" { return PLUS; }
"-" { return MINUS; }
"*" { return MULT; }
"/" { return DIV; }
";" { return SEMICOLON; }
"!" { return NEGATE; }
"=" { return EQUAL; }
.   ;
%%
int yywrap(){
    return 1;
}

struct Node* searchfor(char* Nname){
    struct Node* cur = head;
    
    while (cur->next != NULL){
        cur = cur->next;
        if (cur->name != NULL && strcmp(Nname, cur->name) == 0){
            break;
        }
    }
    
    if (cur->next == NULL && (cur->name == NULL || strcmp(Nname, cur->name) != 0)){
        return makenew(Nname);
    }
    else{
        return cur;
    }
}

struct Node* makenew(char* Nname) {
    struct Node* target;
    target = malloc(sizeof(struct Node));
    target->next = head->next;
    
    char* new = malloc( sizeof(char) * (strlen(Nname) + 1) );
    strcpy (new,Nname);
    target->name = new;
    target->value = 0;
    target->flag = 0;
    
    head->next = target;
    
    return target;
}
