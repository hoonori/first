%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char* msg) {
   fprintf(stderr, "%s\n", msg);
}

extern int yylex(void);
extern int yylineno;

struct Node{
    //type, and for each type has different number of child nodes
    struct Node** childs;
    char type; // refers to type
    char* name; // refers to id name if it is id
    double value; // returns value if constant
    int flag; // 1 means error. initially 0
                // if it is linked listid, it will refer to initialized or not. 0 is uninit, 1 is init
    
    //if used for linked list of id, will contain name and value and flag
};

struct Node* idmain;

struct Node* init();

void listener(struct Node* root);

double calculate(struct Node* expr);

int errorflag;

//int noline;

%}

%union{
    char* NAME;
    double DOUBLE;
    struct Node* NODEP;
}

%token <NAME> ID
%token <DOUBLE> NUMBER
%token PLUS MINUS MULT DIV SEMICOLON NEGATE OPENPAR CLOSEPAR NOTEQUAL EQUAL GREQ LSEQ GREATER LESSER SET TO PRINT IF THEN ELSE ENDIF WHILE DO ENDWHILE
%type <NODEP> program stmt_list stmt assign_stmt print_stmt if_stmt while_stmt exprbool expr expr2 expr3

%%
program:stmt_list {
    //printf("stmt_list\n");
    //printf("program\n");
    //printf("parse ended ! listener start! \n");
    struct Node* ex = init();
    ex->type =  'u';// for ultimate
    ex->flag = yylineno;
    ex->childs = malloc(sizeof(struct Node*) * 1);
    ex->childs[0] = $1;
    listener(ex);
}
;

stmt_list: stmt_list stmt {
    //printf("stmt\n");
    struct Node* ex = init();
    ex->type =  'p';// for procedures
    ex->flag = yylineno;
    ex->childs = malloc(sizeof(struct Node*) * 2);
    ex->childs[0] = $1;
    ex->childs[1] = $2;
    $$ = ex;
}
| stmt {/*printf("stmt\n");*/$$ = $1;}
;
stmt:assign_stmt {/*printf("assign end st\n");*/$$ = $1;}
| print_stmt {/*printf("print end st\n");*/$$ = $1;}
| if_stmt {/*printf("if statement end\n");*/ $$ = $1;}
| while_stmt {/*printf("while statement end\n");*/ $$ = $1;}
;
assign_stmt: SET ID TO exprbool SEMICOLON {//printf("set to\n");
    struct Node* ex = init();
    ex->type =  'S';// for set
    ex->flag = yylineno;
    //noline++;
    ex->childs = malloc(sizeof(struct Node*) * 2);
    struct Node* i = init();
    i->type = 'I';//for id
    i->name = $2;
    ex->childs[0] = i;
    ex->childs[1] = $4;
    $$ = ex;
}
;
print_stmt: PRINT exprbool SEMICOLON {//printf("PRINT\n");
    struct Node* ex = init();
    ex->type =  'P';// for print
    ex->flag = yylineno;
    //noline++;
    ex->childs = malloc(sizeof(struct Node*));
    ex->childs[0] = $2;
    $$ = ex;}
;

if_stmt: IF exprbool THEN stmt_list ENDIF {
    struct Node* ex = init();
    ex->type =  'f';// for IF THEN ENDIF
    ex->flag = yylineno;
    //noline++;
    ex->childs = malloc(sizeof(struct Node*) * 2);
    ex->childs[0] = $2;
    ex->childs[1] = $4;
    $$ = ex;}
| IF exprbool THEN stmt_list ELSE stmt_list ENDIF {
    struct Node* ex = init();
    ex->type =  'F';// for IF THEN ENDIF
    ex->flag = yylineno;
    //noline++;
    ex->childs = malloc(sizeof(struct Node*) * 3);
    ex->childs[0] = $2;
    ex->childs[1] = $4;
    ex->childs[2] = $6;
    $$ = ex;}
;

while_stmt: WHILE exprbool DO stmt_list ENDWHILE {
    struct Node* ex = init();
    ex->type =  'W';// for while statement
    ex->flag = yylineno;
    //noline++;
    ex->childs = malloc(sizeof(struct Node*) * 2);
    ex->childs[0] = $2;
    ex->childs[1] = $4;
    $$ = ex;}
;

exprbool: LESSER expr expr {
    struct Node* ex = init();
    ex->type =  '<';// for less
    ex->flag = yylineno;
    ex->childs = malloc(sizeof(struct Node*) * 2);
    ex->childs[0] = $2;
    ex->childs[1] = $3;
    $$ = ex;
}
| GREATER expr expr {
    struct Node* ex = init();
    ex->type =  '>';// for greater
    ex->flag = yylineno;
    ex->childs = malloc(sizeof(struct Node*) * 2);
    ex->childs[0] = $2;
    ex->childs[1] = $3;
    $$ = ex;
}
| LSEQ expr expr {
    struct Node* ex = init();
    ex->type =  'L';// for less or equal
    ex->flag = yylineno;
    ex->childs = malloc(sizeof(struct Node*) * 2);
    ex->childs[0] = $2;
    ex->childs[1] = $3;
    $$ = ex;
}
| GREQ expr expr {
    struct Node* ex = init();
    ex->type =  'G';// for greater or equal
    ex->flag = yylineno;
    ex->childs = malloc(sizeof(struct Node*) * 2);
    ex->childs[0] = $2;
    ex->childs[1] = $3;
    $$ = ex;
}
| EQUAL expr expr {
    struct Node* ex = init();
    ex->type =  '=';// for equal
    ex->flag = yylineno;
    ex->childs = malloc(sizeof(struct Node*) * 2);
    ex->childs[0] = $2;
    ex->childs[1] = $3;
    $$ = ex;
}
| NOTEQUAL expr expr {
    struct Node* ex = init();
    ex->type =  'N';// for not equal
    ex->flag = yylineno;
    ex->childs = malloc(sizeof(struct Node*) * 2);
    ex->childs[0] = $2;
    ex->childs[1] = $3;
    $$ = ex;}
| expr{$$ = $1;}
;
expr: PLUS expr expr {
    struct Node* ex = init();
    ex->type =  '+';// for plus
    ex->flag = yylineno;
    ex->childs = malloc(sizeof(struct Node*) * 2);
    ex->childs[0] = $2;
    ex->childs[1] = $3;
    $$ = ex;
}
| MINUS expr expr {
    struct Node* ex = init();
    ex->type =  '-';// for minus
    ex->flag = yylineno;
    ex->childs = malloc(sizeof(struct Node*) * 2);
    ex->childs[0] = $2;
    ex->childs[1] = $3;
    $$ = ex;}
| expr2 {$$ = $1;}
;
expr2:MULT expr2 expr2{
    struct Node* ex = init();
    ex->type =  '*';// for gop ha gi
    ex->flag = yylineno;
    ex->childs = malloc(sizeof(struct Node*) * 2);
    ex->childs[0] = $2;
    ex->childs[1] = $3;
    $$ = ex;
}
| DIV expr2 expr2 {
    struct Node* ex = init();
    ex->type =  '/';// for na nu gi
    ex->flag = yylineno;
    ex->childs = malloc(sizeof(struct Node*) * 2);
    ex->childs[0] = $2;
    ex->childs[1] = $3;
    $$ = ex;
}
| expr3 {$$ = $1;}
;
expr3 : NEGATE expr3 {
    struct Node* ex = init();
    struct Node* constnode = init();
    constnode->type = 'C';
    ex->flag = yylineno;
    constnode->value = 0.0;
    ex->type =  '-';// for minus
    ex->childs = malloc(sizeof(struct Node*) * 2);
    ex->childs[0] = constnode;
    ex->childs[1] = $2;
    $$ = ex;
}

| OPENPAR exprbool CLOSEPAR {$$ = $2;}

| NUMBER {
    struct Node* constnode = init();
    constnode->type = 'C';//for constant
    constnode->flag = yylineno;
    constnode->value = $1;
    $$ = constnode;}

| ID {
    struct Node* idnode = init();
    idnode->type = 'I';// for id
    idnode->flag = yylineno;
    idnode->name = $1;
    $$ = idnode;}
;

%%



struct Node* init(){
    struct Node* target;
    target = malloc(sizeof(struct Node));
    
    target->childs = NULL;
    target->type = '?';
    target->name = NULL;
    target->value = 0;
    target->flag = 0;
    return target;
}

int yyparse();

int main(int argc, char** argv)
{
  
    /* yyin and yyout as pointer
    of File type */
    extern FILE *yyin;
  
    /* yyin points to the file input.txt
    and opens it in read mode*/
    yyin = fopen(argv[1], "r");
    
    idmain = init();
    idmain->childs = malloc(sizeof(struct Node*));//make one pointer
    idmain->childs[0] = NULL;
    //initialized idlist head
    
    errorflag = 0;
    //noline = 1;
    
    yyparse();
    
    return 0;
}


struct Node* search(char* Nname, struct Node* idlist){
    struct Node* cur = idlist;
    
    while (cur->childs[0] != NULL){
        cur = cur->childs[0];
        if (cur->name != NULL && strcmp(Nname, cur->name) == 0){
            break;
        }
    }
    
    if (cur->childs[0] == NULL && (cur->name == NULL || strcmp(Nname, cur->name) != 0)){
        return NULL;
    }
    else{
        return cur;
    }
}


struct Node* makenew(char* Nname, struct Node* idlist) {
    struct Node* target;
    target = malloc(sizeof(struct Node));
    target->childs = malloc(sizeof(struct Node*));//make one pointer
    target->childs[0] = idlist->childs[0];
    
    char* new = malloc( sizeof(char) * (strlen(Nname)) );
    strcpy (new,Nname);
    target->name = new;
    
    idlist->childs[0] = target;
    
    return target;
}


struct Node* searchNmake(char* Nname, struct Node* idlist){
    struct Node* cur = idlist;
    
    while (cur->childs[0] != NULL){
        cur = cur->childs[0];
        if (cur->name != NULL && strcmp(Nname, cur->name) == 0){
            break;
        }
    }
    
    if (cur->childs[0] == NULL && (cur->name == NULL || strcmp(Nname, cur->name) != 0)){
        return makenew(Nname, idlist);
    }
    else{
        return cur;
    }
}

double calculate(struct Node* expr){
    if (expr->type == '<'){//lesser
        if (calculate(expr->childs[0]) < calculate(expr->childs[1])){return 1.0;}
        else {return 0.0;}
    }
    else if (expr->type == '>'){//greater
        if (calculate(expr->childs[0]) > calculate(expr->childs[1])){return 1.0;}
        else {return 0.0;}
    }
    else if (expr->type == 'L'){//less or equal
        if (calculate(expr->childs[0]) <= calculate(expr->childs[1])){return 1.0;}
        else {return 0.0;}
    }
    else if (expr->type == 'G'){//greater or equal
        if (calculate(expr->childs[0]) >= calculate(expr->childs[1])){return 1.0;}
        else {return 0.0;}
    }
    else if (expr->type == '='){//equal
        if (calculate(expr->childs[0]) == calculate(expr->childs[1])){return 1.0;}
        else {return 0.0;}
    }
    else if (expr->type == 'N'){//not equal
        if (calculate(expr->childs[0]) != calculate(expr->childs[1])){return 1.0;}
        else {return 0.0;}
    }
    else if (expr->type == '+'){//plus
        return calculate(expr->childs[0]) + calculate(expr->childs[1]);
    }
    else if (expr->type == '-'){//minus
        return calculate(expr->childs[0]) - calculate(expr->childs[1]);
    }
    else if (expr->type == '*'){//gop ha gi
        return calculate(expr->childs[0]) * calculate(expr->childs[1]);
    }
    else if (expr->type == '/'){//na nu gi
        double left = calculate(expr->childs[0]);
        double right = calculate(expr->childs[1]);
        if (right == 0){
            errorflag = expr->flag; return 1;
        }
        else{
            return left / right;
        }
    }
    else if (expr->type == 'C'){//constant
        return expr->value;
    }
    else if (expr->type == 'I'){//VARIABLE
        struct Node* looked = search(expr->name, idmain);
        if (looked == NULL){errorflag = -1; printf("Unknown variable : %s\n", expr->name);return 1;}
        else if (looked->flag == 1){return looked->value;}//if exists and initialized
        else{errorflag = -1; printf("Unknown variable : %s\n", expr->name);return 1;}
    }
    else{
        errorflag = expr->flag; return 1;
    }
}

void listener(struct Node* root){
    if (errorflag){return;}
    //printf("noline = %d\n", noline);
    if (root->type == 'u')//ultimate root
    {
        //printf("root\n");
        listener(root->childs[0]);
    }
    else if(root->type == 'p') {//procedures
        //printf("procedures -> split into left and right\n");
        listener(root->childs[0]);
        listener(root->childs[1]);
    }
    else if (root->type == 'S'){//SET statement
        //printf("SET statement\n");
        double result = calculate(root->childs[1]);
        if (errorflag){ if (errorflag > 0) printf("error : %d\n", errorflag); return;}
        struct Node* variable = searchNmake(root->childs[0]->name , idmain);
        variable->value = result;
        variable->flag = 1;
    }
    else if (root->type == 'P'){//PRINT statement
        //printf("PRINT statement\n");
        double result = calculate(root->childs[0]);
        if (errorflag){ if (errorflag > 0) printf("error : %d\n", errorflag); return;}
        printf("%lf\n", result);
    }
    else if (root->type == 'f'){//IF THEN ENDIF
        //printf("IF THEN ENDIF\n");
        if (0.0 != calculate(root->childs[0])){
            if (errorflag){ if (errorflag > 0) printf("error : %d\n", errorflag); return;}
            listener(root->childs[1]);
        }
        if (errorflag){ if (errorflag > 0) printf("error : %d\n", errorflag); return;}
    }
    else if (root->type == 'F'){//IF THEN ELSE ENDIF
        //printf("IF THEN ENDIF\n");
        if (0.0 != calculate(root->childs[0])){
            if (errorflag){ if (errorflag > 0) printf("error : %d\n", errorflag); return;}
            listener(root->childs[1]);
        }
        else{
            if (errorflag){ if (errorflag > 0) printf("error : %d\n", errorflag); return;}
            listener(root->childs[2]);
        }
        
    }
    else if (root->type == 'W'){//while statement
        //printf("WHILE STATEMENT\n");
        while (0.0 != calculate(root->childs[0])){
            if (errorflag){ if (errorflag > 0) printf("error : %d\n", errorflag); return;}
            listener(root->childs[1]);
        }
        if (errorflag){ if (errorflag > 0) printf("error : %d\n", errorflag); return;}
    }
    return;
}
