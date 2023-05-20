/*Seccion de definiciones*/
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern char* yytext;
extern FILE* yyin;

void yyerror(const char* s) {
    fprintf(stderr, "%s\n", s);
}
%}

/*Declaraciones y uniones*/
%union {
    char* str;
}

/*Tokens*/

%token <str> TEXT
%token CL IMP CH EM PCK BOL STT VD DFT FTL EXD PBC PTD ABST
%token LPAREN RPAREN

/*Tipos*/

%type <str> program statement

/*Variables globales*/

%{
    FILE* output_file;  // Archivo de salida para la versión completa del script
%}

/*Reglas de la gramatica*/

%%

program : statement { fprintf(output_file, "%s\n", $1); }
        | program statement { fprintf(output_file, "%s\n", $2); }
        ;

statement : CL LPAREN TEXT RPAREN { $$ = strdup($3); asprintf(&$$, "class('%s')", $3); }
          | IMP LPAREN TEXT RPAREN { $$ = strdup($3); asprintf(&$$, "import('%s')", $3); }
          | CH LPAREN TEXT RPAREN { $$ = strdup($3); asprintf(&$$, "char('%s')", $3); }
          | EM LPAREN TEXT RPAREN { $$ = strdup($3); asprintf(&$$, "enum('%s')", $3); }
          | PCK LPAREN TEXT RPAREN { $$ = strdup($3); asprintf(&$$, "package('%s')", $3); }
          | BOL LPAREN TEXT RPAREN { $$ = strdup($3); asprintf(&$$, "boolean('%s')", $3); }
          | STT LPAREN TEXT RPAREN { $$ = strdup($3); asprintf(&$$, "static('%s')", $3); }
          | VD LPAREN TEXT RPAREN { $$ = strdup($3); asprintf(&$$, "void('%s')", $3); }
          | DFT LPAREN TEXT RPAREN { $$ = strdup($3); asprintf(&$$, "default('%s')", $3); }
          | FTL LPAREN TEXT RPAREN { $$ = strdup($3); asprintf(&$$, "float('%s')", $3); }
          | EXD LPAREN TEXT RPAREN { $$ = strdup($3); asprintf(&$$, "extends('%s')", $3); }
          | PBC LPAREN TEXT RPAREN { $$ = strdup($3); asprintf(&$$, "public('%s')", $3); }
          | PTD LPAREN TEXT RPAREN { $$ = strdup($3); asprintf(&$$, "protected('%s')", $3); }
          | ABST LPAREN TEXT RPAREN { $$ = strdup($3); asprintf(&$$, "abstract('%s')", $3); }
          ;

%%

/*Funcion principal*/

int main(int argc, char* argv[]) {
    if (argc < 3) {
        printf("Uso: %s archivo_de_entrada archivo_de_salida\n", argv[0]);
        return 1;
    }

    FILE* input_file = fopen(argv[1], "r");
    if (!input_file) {
        printf("No se pudo abrir el archivo de entrada.\n");
        return 1;
    }

    output_file = fopen(argv[2], "w");
    if (!output_file) {
        printf("No se pudo crear el archivo de salida.\n");
        fclose(input_file);
        return 1;
    }

    yyin = input_file;
    yyparse();

    fclose(input_file);
    fclose(output_file);

    return 0;
}
