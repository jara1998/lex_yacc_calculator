%{
   #include <stdlib.h>
   #include <iostream>
   #include "yj2483.calc.tab.h"
   #include <string>
   #include <unordered_map>
%}
%option noyywrap
extern int yyerror(const char *p);

%%
"+"	{ return ADD; }
"-"	{ return SUB; }
"*"	{ return MUL; }
"/"	{ return DIV; }
"|"     { return ABS; }
"("     { return L_BRACKET; }
")"     { return R_BRACKET; }
[0-9]+(\.[0-9]+)?       { yylval.d_num = atof(yytext); return NUMBER; }
("pi")|("PI")	         { return PI; }
"^"                     { return POW; }
("mod")|("MOD")|("%")           { return MOD; }
"!"                     { return FACTORIAL; }
("sqrt")|("SQRT")         { return SQRT; }
("ABS")|("abs")           { return ABS; }
("floor")|("FLOOR")       { return FLOOR;}
("ceil")|("CEIL")         { return CEIL;}
("cos")|("COS")           { return COS; }
("sin")|("SIN")           { return SIN; }
("tan")|("TAN")           { return TAN; }
("log2")|("LOG2")         { return LOG2; }
("log10")|("LOG10")       { return LOG10; }
("gbp_to_usd")|("GBP_To_USD")         { return GBP_TO_USD; }
("usd_to_gbp")|("USD_To_GBP")         { return USD_TO_GBP; }
("gbp_to_euro")|("GBP_To_EURO")       { return GBP_TO_EURO; }
("euro_to_gbp")|("EURO_To_GBP")       { return EURO_TO_GBP; }
("usd_to_euro")|("USD_To_EURO")       { return USD_TO_EURO; }
("euro_to_usd")|("EURO_To_USD")       { return EURO_TO_USD; }
("cel_to_fah")|("CEL_To_FAH")         { return CEL_TO_FAH; }
("fah_to_cel")|("FAH_To_CEL")         { return FAH_TO_CEL; }
("mi_to_km")|("MI_To_KM")             { return MI_TO_KM; }
("km_to_mi")|("KM_To_MI")             { return KM_TO_MI; }
"="                                 { return EQUALS; }
("var"|"VAR")                       { return VAR_KEYWORD; }
[a-zA-Z]+[a-zA-Z0-9]*               { yylval.var_name = std::hash<std::string>{}(yytext); return VARIABLE; }
\n      { return EOL; }
"//".*          
[ \t\r]+   { /* ignore white space */ }
.                       { std::cerr << "ERROR: Undefined symbol" << std::endl; exit(1); }
%%