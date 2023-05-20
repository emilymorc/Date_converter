/*Seccion de definiciones*/
%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"
extern FILE* yyin;
extern FILE* yyout;
extern char* yytext;
extern char* strdup(const char*);
%}

%option noyywrap

%{
void convertAndPrint(const char* dateContent);
%}

DIGIT       [0-9] 
YEAR        {DIGIT}{DIGIT}{DIGIT}{DIGIT}
MONTH       0{DIGIT}|1[0-2]
DAY         0{DIGIT}|[1-2][0-9]|3[0-1]
HOUR        [0-1]{DIGIT}|2[0-3]
MINUTE      [0-5]{DIGIT}
SECOND      [0-5]{DIGIT}
CONTENT     [^\n]*

%%
{YEAR}"-"{MONTH}"-"{DAY}"T"{HOUR}":"{MINUTE}":"{SECOND}":"{CONTENT}   { yylval.str = strdup(yytext); return DATE_CONTENT; }
.|\n        { return yytext[0]; }
%%

