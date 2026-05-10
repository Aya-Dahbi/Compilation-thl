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

%error-verbose

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

%left PLUS MINUS
%left MUL DIV MOD
%right POW
%left UMINUS

%%

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

instr:
      declaration
    | affectation
    | lecture
    | ecriture
    | boucle
;

declaration:
      INT_KW ID
;

affectation:
      ID ASSIGN expr
;

lecture:
      READ_KW LPAREN ID RPAREN
;
ecriture:
      WRITE_KW expr
;

boucle:
      WHILE_KW LPAREN cond RPAREN DO_KW NEWLINE listinstr OD_KW
;

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

void yyerror(const char *s)
{
    fprintf(stderr, "[ERREUR] Ligne %d : %s\n", yylineno, s);
    nb_erreurs++;
}

int main()
{
    yyparse();
    return 0;
}
