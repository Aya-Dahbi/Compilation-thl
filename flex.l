%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%option noyywrap
%option yylineno

%%

"begin"   { return BEGIN_KW; }
"end"     { return END_KW;   }
"int"     { return INT_KW;   }
"write"   { return WRITE_KW; }
"read"    { return READ_KW;  }
"while"   { return WHILE_KW; }
"do"      { return DO_KW;    }
"od"      { return OD_KW;    }

[a-zA-Z][a-zA-Z0-9]*  { yylval.str = strdup(yytext); return ID;  }
[0-9]+                 { yylval.num = atoi(yytext);   return NUM; }

":="  { return ASSIGN; }
"-"   { return MINUS;  }
"*"   { return TIMES;  }
"/"   { return DIV;    }
"%"   { return MOD;    }
"^"   { return POW;    }

">="  { return GTE; }
"<="  { return LTE; }
"!="  { return NEQ; }
"=="  { return EQ;  }
">"   { return GT;  }
"<"   { return LT;  }

"("   { return LPAREN; }
")"   { return RPAREN; }

[ \t\n]  { /* ignorer */ }

.  { fprintf(stderr, "Erreur ligne %d : caractere inconnu '%s'\n", yylineno, yytext); }

%%
