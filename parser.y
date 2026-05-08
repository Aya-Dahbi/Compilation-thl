%{
#include <stdio.h>
#include <stdlib.h>

/* Declarations des fonctions externes fournies par Flex */
extern int yylex(void);
extern int yylineno;
extern char* yytext;

/* Fonction de gestion des erreurs */
void yyerror(const char *s);
%}

/* Definition des types pour les valeurs */
%union {
    int num;
    char* str;
}

/* Declaration des tokens */
%token BEGIN_KW END_KW INT_KW WRITE_KW READ_KW WHILE_KW DO_KW OD_KW
%token ASSIGN MINUS TIMES DIV MOD POW
%token GTE LTE NEQ EQ GT LT
%token LPAREN RPAREN

/* Association des types aux tokens qui transportent une valeur */
%token <str> ID
%token <num> NUM

/* Gestion des priorites et de l'associativite */
%left MINUS
%left TIMES DIV MOD
%right POW

/* Point d'entree de la grammaire */
%start program

%%

program:
    BEGIN_KW listinstr END_KW
    ;

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
    fprintf(stderr, "Erreur syntaxique a la ligne %d : %s (proche de '%s')\n", yylineno, s, yytext);
}

int main(void) {
    if (yyparse() == 0) {
        printf("Analyse reussie : le programme respecte la grammaire.\n");
    } else {
        printf("Echec de l'analyse.\n");
    }
    return 0;
}