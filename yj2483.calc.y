%{
#include <iostream>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "yj2483.calc.tab.h"
#include "util.h"
#include <math.h>
#include <map>
#include <string>
#include <unordered_map>
#include <cstdlib>
// #include "var_table.h"
int yylex(); // A function that is to be generated and provided by flex,
             // which returns a next token when called repeatedly.
int yyerror(const char *p) { std::cerr << "ERROR: " << p << std::endl; };
// using namespace std;
extern FILE* yyin;
std::map<size_t, double> var_table;
%}

%union {
    double d_num;
    size_t var_name;
    /* You may include additional fields as you want. */
    /* char op; */
}


%start program_input
%token <d_num> L_BRACKET R_BRACKET
%token <d_num> ADD SUB MUL DIV
%token <d_num> PI EOL POW
%token <d_num> NUMBER
%token <d_num> SQRT ABS
%token <d_num> FACTORIAL MOD FLOOR CEIL
%token <d_num> COS SIN TAN 
%token <d_num> LOG2 LOG10
%token <d_num> GBP_TO_USD USD_TO_GBP
%token <d_num> GBP_TO_EURO EURO_TO_GBP
%token <d_num> USD_TO_EURO EURO_TO_USD
%token <d_num> CEL_TO_FAH FAH_TO_CEL
%token <d_num> MI_TO_KM KM_TO_MI
%token <d_num> VAR_KEYWORD
%token <d_num> EQUALS
%token <var_name> VARIABLE // variable name
%type <d_num> program_input
%type <d_num> line
%type <d_num> calculation
%type <d_num> expr
%type <d_num> assignment
%type <d_num> constant
%type <d_num> function
%type <d_num> conversion
%type <d_num> log_function
%type <d_num> trig_function
%type <d_num> temp_conversion
%type <d_num> dist_conversion


/* Resolve the ambiguity of the grammar by defining precedence. */

/* Order of directives will determine the precedence. */
%left ADD SUB    /* left means left-associativity. */
%left DIV MUL
%left SQRT
%right POW
%right L_BRACKET R_BRACKET

%%
program_input : /*epsilon*/
              | program_input line         
              ;
              
line : /* epsilon */
    | line calculation EOL { printf("=%.2f\n", $2); }
    | line EOL 
    ;

calculation : expr                     
            | assignment
            ;

constant : PI                               { $$ = 3.14; }
         ;

expr : SUB expr                             { $$ = -$2; }
     | NUMBER
     | VARIABLE                             { 	
		 										if (var_table.count($1)) {
		 											$$ = var_table[$1]; 
												} else {
													std::cerr << "ERROR: Undefined symbol" << std::endl; exit(1);
												}
	 										}
     | constant
     | function
     | expr MUL expr                        { $$ = $1 * $3; }
     | expr DIV expr                        {       
                                              if ($3 == 0) {
                                                  yyerror("Invalid operation"); 
                                                  exit(1);
                                              } else {
                                                  $$ = $1 / $3;
                                              }
                                            }
     | expr ADD expr                        { $$ = $1 + $3; }
     | expr SUB expr                        { $$ = $1 - $3; }
     | expr POW expr                        { $$ = pow($1, $3); }
     | expr MOD expr                        { $$ = modulo($1, $3); }
     | L_BRACKET expr R_BRACKET             { $$ = $2; }
     ;

function : conversion
         | log_function
         | trig_function
         | expr FACTORIAL                   { $$ = factorial($1); }
         | SQRT expr                        { $$ = sqrt($2); }
         | ABS expr                         { $$ = fabs($2); }
         | FLOOR expr                       { $$ = floor($2); }
         | CEIL expr                        { $$ = ceil($2); }
         
trig_function : COS expr                    { $$ = cos($2); }
              | SIN expr                    { $$ = sin($2); }
              | TAN expr                    { $$ = tan($2); }
              ;

log_function : LOG2 expr                    { $$ = log2($2); }
             | LOG10 expr                   { $$ = log10($2); }
             ;

conversion : temp_conversion
           | dist_conversion
           | expr GBP_TO_USD                { $$ = gbp_to_usd($1); }
           | expr USD_TO_GBP                { $$ = usd_to_gbp($1); }
           | expr GBP_TO_EURO               { $$ = gbp_to_euro($1); }
           | expr EURO_TO_GBP               { $$ = euro_to_gbp($1); }
           | expr USD_TO_EURO               { $$ = usd_to_euro($1); }
           | expr EURO_TO_USD               { $$ = euro_to_usd($1); }
           ;

temp_conversion : expr FAH_TO_CEL           { $$ = fah_to_cel($1); }
                | expr CEL_TO_FAH           { $$ = cel_to_fah($1); }
                ;
dist_conversion : expr MI_TO_KM             { $$ = m_to_km($1); }
                | expr KM_TO_MI             { $$ = km_to_m($1); }
                ;
assignment : VAR_KEYWORD VARIABLE EQUALS calculation        { var_table[$2] = $4; $$ = $4;}
%%

int main(int argc, char **argv)
{
    std::cout.precision(2);
    char c[20];
	printf("Use the default text file as input? (y/n)");
	scanf("%s", c);
    if (strcmp(c, "y") == 0 || strcmp(c, "Y") == 0) {
        yyin = fopen("yj2483.input.txt", "r");
		while(!feof(yyin)){
            yyparse();
        }
    } else {
        return yyparse();
    }
}