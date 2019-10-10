#include <stdio.h>
#include <stdlib.h>

extern int errorflag;

struct Node{
    struct Node* next;
    char* name;
    double value;
    int flag;
};

struct Node* head;

struct Node* init(){
    struct Node* target;
    target = malloc(sizeof(struct Node));
    target->next = NULL;
    target->name = NULL;
    target->value = 0;
    target->flag = 0;
    return target;
}

void clean(struct Node* target){
    struct Node* prev;
    struct Node* cur;
    cur = target;
    
    if (cur == NULL){return;}
    
    while (cur->next != NULL){
        prev = cur;
        cur = cur->next;
        if (prev->name != NULL){free(prev->name);}
        free(prev);
    }
    if (cur->name != NULL){free(cur->name);}
    free(cur);
    return;
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
    
    head = init();
    errorflag = 0;
    
    yyparse();
    
    clean(head);
    return 0;
}

