%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex(void);
extern int yyerror(char *s);

struct Node{
    struct Node* next;
    char* name;
    double value;
    int flag;
};



int errorflag;

extern struct Node* head;

    %}

%union{
    struct Node* NODEP;
    double DOUBLE;
}

%token <NODEP> VARIABLE
%token <DOUBLE> NUMBER
%token PLUS MINUS MULT DIV SEMICOLON NEGATE EQUAL
%type <DOUBLE> program sentence calcsen terminal assign

%%
program: {}
| sentence SEMICOLON program {}
;

sentence:
assign {errorflag = 0;}
| calcsen { if (errorflag == 0){printf("= %lf\n", $1);}
    errorflag = 0;
}
;

assign:
EQUAL VARIABLE calcsen {
    $2->value = $3;
    $2->flag = 1;
}
;

calcsen:
 PLUS calcsen calcsen {$$ = $2 + $3;}
| MINUS calcsen calcsen {$$ = $2 - $3;}
| MULT calcsen calcsen {$$ = $2 * $3;}
| DIV calcsen calcsen {$$ = $2 / $3;}
| terminal {}
;

terminal:
NEGATE terminal {$$ = 0 - $2;}
| NUMBER {$$ = $1;}
| "(" calcsen ")" {$$ = $2;}
| VARIABLE {
    if ($1->flag == 0){
        yyerror($1->name);
    }
    else{
        $$ = $1->value;
    }
}
;
%%

int yyerror(char *s)
{
    errorflag = 1;
    return printf("unknown variable: %s\n", s);
}
