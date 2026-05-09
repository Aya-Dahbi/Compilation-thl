%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex(void);
extern int yylineno;
extern char* yytext;

void yyerror(const char *s);
%}

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
    | error END_KW
    {
        fprintf(stderr, "[ERREUR] Ligne %d : 'begin' manquant\n", yylineno);
        yyerrok;
    }
    | BEGIN_KW listinstr
    {
        fprintf(stderr, "[ERREUR] Ligne %d : 'end' manquant\n", yylineno);
        yyerrok;
    }
    ;

listinstr:
    instr listinstr
    | instr
    | error listinstr
    {
        fprintf(stderr, "[ERREUR] Ligne %d : instruction invalide\n", yylineno);
        yyerrok;
    }
    ;

instr:
    INT_KW ID
    | ID ASSIGN expr
    | ID error expr
    {
        fprintf(stderr, "[ERREUR] Ligne %d : ':=' manquant apres '%s'\n", yylineno, $1);
        yyerrok;
    }
    | WRITE_KW expr
    | READ_KW LPAREN ID RPAREN
    | READ_KW ID
    {
        fprintf(stderr, "[ERREUR] Ligne %d : parentheses manquantes → ecrivez read(%s)\n", yylineno, $2);
        yyerrok;
    }
    | WHILE_KW LPAREN cond RPAREN DO_KW listinstr OD_KW
    | WHILE_KW LPAREN cond RPAREN listinstr OD_KW
    {
        fprintf(stderr, "[ERREUR] Ligne %d : 'do' manquant apres la condition\n", yylineno);
        yyerrok;
    }
    | WHILE_KW LPAREN cond RPAREN DO_KW listinstr
    {
        fprintf(stderr, "[ERREUR] Ligne %d : 'od' manquant\n", yylineno);
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
    GT | LT | GTE | LTE | NEQ | EQ
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "[ERREUR] Ligne %d : %s (proche de '%s')\n",
            yylineno, s, yytext);
}

int main(void) {
    if (yyparse() == 0) {
        printf("SUCCES : programme valide.\n");
    } else {
        printf("ECHEC : programme invalide.\n");
    }
    return 0;
}
