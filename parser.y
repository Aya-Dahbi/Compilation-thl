%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex(void);
extern int yylineno;
extern char* yytext;

void yyerror(const char *s);
%}

%define parse.error verbose

%union {
    int num;
    char* str;
}

%token BEGIN_KW END_KW INT_KW WRITE_KW READ_KW WHILE_KW DO_KW OD_KW
%token ASSIGN MINUS TIMES DIV MOD POW
%token GTE LTE NEQ EQ GT LT
%token LPAREN RPAREN

%token <str> ID
%token <num> NUM

%left MINUS
%left TIMES DIV MOD
%right POW

%start program

%%

program:
    BEGIN_KW listinstr END_KW
    ;

/* Respect de la recursivite droite de l'enonce */
listinstr:
    instr listinstr
    | instr
    ;

instr:
    INT_KW ID
    | ID ASSIGN expr
    | WRITE_KW expr
    | READ_KW LPAREN ID RPAREN
    | WHILE_KW LPAREN cond RPAREN DO_KW listinstr OD_KW
    | error { 
        fprintf(stderr, "--> Tentative de reprise de l'analyse apres l'erreur.\n");
        yyerrok; 
      }
    ;

expr:
    expr MINUS expr
    | expr TIMES expr
    | expr DIV expr
    | expr MOD expr
    | expr POW expr
    | ID
    | NUM
    | LPAREN expr RPAREN
    ;

cond:
    expr condsymb expr
    ;

condsymb:
    GT 
    | LT 
    | GTE 
    | LTE 
    | NEQ 
    | EQ
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "\n[ERREUR SYNTAXIQUE] Ligne %d : %s (symbole problematique : '%s')\n", yylineno, s, yytext);
}

int main(void) {
    printf("Demarrage du Compilateur\n");
    if (yyparse() == 0) {
        printf("\n=> SUCCES ! Analyse terminee, aucune erreur syntaxique detectee.\n");
    } else {
        printf("\n=> ECHEC ! L'analyse a echoue en raison des erreurs ci-dessus.\n");
    }
    return 0;
}
