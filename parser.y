/*Seccion de definiones*/
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*Declaracion de variables externas*/

extern int yylex();
extern int yyparse();
extern FILE* yyin;
extern FILE* yyout;
extern char* yytext;
extern char* strdup(const char*);

/*Declaracion de funciones*/

void yyerror(const char* s);
void convertAndPrint(const char* dateContent);
%}

%union {
    char* str;
}

%token <str> DATE_CONTENT

%type <str> log_entries log_entry date_content

%start log_entries

%%
/* Reglas de la gramática */
log_entries:
    | log_entries log_entry
    ;

log_entry:
    date_content '\n' { convertAndPrint($1); free($1); }
    ;

date_content:
    DATE_CONTENT { $$ = $1; }
    ;

%%

/* Implementación de las funciones */

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}

void convertAndPrint(const char* dateContent) {
    // Extraer las partes de la fecha y hora del contenido
    int year, month, day, hour, minute, second;
    char text[100];
    sscanf(dateContent, "%d-%d-%dT%d:%d:%d:%[^\n]", &year, &month, &day, &hour, &minute, &second, text);

    // Construir la nueva cadena de fecha y hora en el formato deseado
    char newDate[20];
    sprintf(newDate, "%04d%02d%02dT%02d%02d%02dZ", year, month, day, hour, minute, second);

    // Imprimir la nueva cadena en el archivo de salida
    fprintf(yyout, "%s: %s\n", newDate, text);
}

/* Función principal */

int main(int argc, char* argv[]) {
    if (argc != 3) {
        printf("Uso: %s archivo_entrada archivo_salida\n", argv[0]);
        return 1;
    }

    FILE* inputFile = fopen(argv[1], "r");
    if (!inputFile) {
        printf("No se pudo abrir el archivo de entrada.\n");
        return 1;
    }

    FILE* outputFile = fopen(argv[2], "w");
    if (!outputFile) {
        printf("No se pudo abrir el archivo de salida.\n");
        fclose(inputFile);
        return 1;
    }

    yyin = inputFile;
    yyout = outputFile;

    yyparse();

    fclose(inputFile);
    fclose(outputFile);

    return 0;
}
