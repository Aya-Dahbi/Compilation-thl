%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap
%option yylineno

LETTER      [a-zA-Z]
DIGIT       [0-9]

IDF         {LETTER}({LETTER}|{DIGIT})*
NUMBER      {DIGIT}+
WHITESPACE  [ \t\r\n]+

%%

"begin"     { return BEGIN_KW; }
"end"       { return END_KW; }

"int"       { return INT_KW; }

"write"     { return WRITE_KW; }
"read"      { return READ_KW; }

"while"     { return WHILE_KW; }
"do"        { return DO_KW; }
"od"        { return OD_KW; }

":="        { return ASSIGN; }

">="        { return GTE; }
"<="        { return LTE; }
"!="        { return NEQ; }
"=="        { return EQ; }

">"         { return GT; }
"<"         { return LT; }

"-"         { return MINUS; }
"*"         { return TIMES; }
"/"         { return DIV; }
"%"         { return MOD; }
"^"         { return POW; }

"("         { return LPAREN; }
")"         { return RPAREN; }

{NUMBER}    {
                yylval.num = atoi(yytext);
                return NUM;
            }

{IDF}       {
                yylval.str = strdup(yytext);
                return ID;
            }

{WHITESPACE}  { }

.           {
                fprintf(stderr,
                        "Erreur lexicale ligne %d : caractere inconnu '%s'\n",
                        yylineno,
                        yytext);
            }

%%
