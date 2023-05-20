/*Seccion de definiciones*/
%{
#include "parser.tab.h"
%}
/*Tokens*/
%%
cl  { return CL; }
imp { return IMP; }
ch  { return CH; }
em  { return EM; }
pck { return PCK; }
bol { return BOL; }
stt { return STT; }
vd  { return VD; }
dft { return DFT; }
ftl { return FTL; }
exd { return EXD; }
pbc { return PBC; }
ptd { return PTD; }
abst { return ABST; }
\(  { return LPAREN; }
\)  { return RPAREN; }
\'[^\']*\'   { yylval.str = strdup(yytext+1); yylval.str[strlen(yytext)-2] = '\0'; return TEXT; }
[ \t\r]+  { /* Ignorar espacios en blanco */ }
.   { /* Ignorar caracteres inválidos */ }
%%
/*Codigo de usuario*/
int yywrap() {
    return 1;
}
