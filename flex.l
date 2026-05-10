%option noyywrap
%option yylineno

%{

#include "parser.tab.h"
#include <stdio.h>

%}

digit      [0-9]
letter     [a-zA-Z]
id         {letter}({letter}|{digit})*

%%

"begin"        { return BEGIN_KW; }
"end"          { return END_KW; }

"int"          { return INT_KW; }

"read"         { return READ_KW; }
"write"        { return WRITE_KW; }

"while"        { return WHILE_KW; }
"do"           { return DO_KW; }
"od"           { return OD_KW; }

":="           { return ASSIGN; }

"==="          { return STRICT_EQ; }
"=="           { return EQ; }
"!="           { return NE; }
">="           { return GE; }
"<="           { return LE; }

">"            { return GT; }
"<"            { return LT; }

"+"            { return PLUS; }
"-"            { return MINUS; }
"*"            { return MUL; }
"/"            { return DIV; }
"%"            { return MOD; }
"^"            { return POW; }

"("            { return LPAREN; }
")"            { return RPAREN; }

{digit}+       { return NUM; }

{id}           { return ID; }

[ \t\r]+       ;

\n             { return NEWLINE; }

. {
    fprintf(stderr,
            "Erreur lexicale ligne %d : caractere inconnu '%s'\n",
            yylineno,
            yytext);
}

%%
