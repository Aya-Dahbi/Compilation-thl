%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylineno;
extern char* yytext;

int yylex();

int nb_erreurs = 0;

void yyerror(const char *s);
%}

/* ================= CONFIGURATION ================= */
%error-verbose

/* ================= TOKENS ================= */
%token BEGIN_KW "begin"
%token END_KW "end"
%token INT_KW "int"
%token READ_KW "read"
%token WRITE_KW "write"
%token WHILE_KW "while"
%token DO_KW "do"
%token OD_KW "od"

%token ID "identifiant"
%token NUM "nombre"
%token ASSIGN ":="
%token PLUS "+"
%token MINUS "-"
%token MUL "*"
%token DIV "/"
%token MOD "%"
%token POW "^"
%token GT ">"
%token LT "<"
%token GE ">="
%token LE "<="
%token EQ "=="
%token NE "!="
%token STRICT_EQ "==="
%token LPAREN "("
%token RPAREN ")"
%token NEWLINE "fin de ligne"

/* ================= PRIORITES ================= */
%left PLUS MINUS
%left MUL DIV MOD
%right POW
%left UMINUS

%%

/* ================= PROGRAM ================= */

program:
      optional_newlines BEGIN_KW NEWLINE listinstr END_KW optional_newlines
      {
          if(nb_erreurs == 0)
              printf("SUCCES : programme syntaxiquement correct.\n");
          else
              printf("ECHEC : %d erreur(s) detectee(s).\n", nb_erreurs);
      }
;

optional_newlines:
      /* vide */
    | optional_newlines NEWLINE
;

/* ================= LISTE D'INSTRUCTIONS ================= */

listinstr:
      listinstr statement
    | statement
;

statement:
      instr NEWLINE
    | NEWLINE  /* Lignes vides ignorees */
    | error NEWLINE 
      { 
          yyerrok; 
      }
;

/* ================= INSTRUCTIONS ================= */

instr:
      declaration
    | affectation
    | lecture
    | ecriture
    | boucle
;

/* ================= DECLARATION ================= */

declaration:
      INT_KW ID
;

/* ================= AFFECTATION ================= */

affectation:
      ID ASSIGN expr
;

/* ================= LECTURE ================= */

lecture:
      READ_KW LPAREN ID RPAREN
;

/* ================= ECRITURE ================= */

ecriture:
      WRITE_KW expr
;

/* ================= BOUCLE ================= */

boucle:
      WHILE_KW LPAREN cond RPAREN DO_KW NEWLINE listinstr OD_KW
;

/* ================= EXPRESSIONS ================= */

expr:
      expr PLUS expr
    | expr MINUS expr
    | expr MUL expr
    | expr DIV expr
    | expr MOD expr
    | expr POW expr
    | MINUS expr %prec UMINUS
    | LPAREN expr RPAREN
    | ID
    | NUM
;

/* ================= CONDITIONS ================= */

cond:
      expr condsymb expr
;

condsymb:
      GT
    | LT
    | GE
    | LE
    | EQ
    | NE
    | STRICT_EQ
;

%%

/* ================= ERREURS ================= */

void yyerror(const char *s)
{
    fprintf(stderr, "[ERREUR] Ligne %d : %s\n", yylineno, s);
    nb_erreurs++;
}

/* ================= MAIN ================= */

int main()
{
    yyparse();
    return 0;
}
