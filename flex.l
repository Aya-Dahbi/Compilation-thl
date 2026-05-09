%{
#include "parser.tab.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
%}

%option noyywrap
%option yylineno

LETTER      [a-zA-Z]
DIGIT       [0-9]

IDF         {LETTER}({LETTER}|{DIGIT})*
NUMBER      {DIGIT}+

WHITESPACE  [ \t\n]+

%%

"begin"        { return BEGIN_KW; }
"end"          { return END_KW; }

"int"          { return INT_KW; }

"write"        { return WRITE_KW; }
"read"         { return READ_KW; }

"while"        { return WHILE_KW; }
"do"           { return DO_KW; }
"od"           { return OD_KW; }

{IDF}
{
    yylval.str = strdup(yytext);
    return ID;
}

{NUMBER}
{
    yylval.num = atoi(yytext);
    return NUM;
}

":="           { return ASSIGN; }

"-"            { return MINUS; }
"*"            { return TIMES; }
"/"            { return DIV;   }
"%"            { return MOD;   }
"^"            { return POW;   }

">="           { return GTE; }
"<="           { return LTE; }
"!="           { return NEQ; }
"=="           { return EQ;  }

">"            { return GT;  }
"<"            { return LT;  }

"("            { return LPAREN; }
")"            { return RPAREN; }

{WHITESPACE}   { }

.
{
    fprintf(stderr,
            "Erreur lexicale ligne %d : caractere inconnu '%s'\n",
            yylineno,
            yytext);
}

%%
