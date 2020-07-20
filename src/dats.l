%option noyywrap

%{
#include <stdio.h>
#include <stdint.h>
#include <math.h>

#include "dats.tab.h"
#include "notes.h"

#define YY_DECL int yylex()
uint32_t dats_line = 1;

double FREQUENCY;

%}

%s bpm

%%

(\/\/).*            {/* comment */}
"BPM"               {BEGIN(bpm); return BPM;}
"BEGIN"             {return BEG;}
"END"               {return END;}
"NOTE"              {return NOTE;}

"C"                 {
#ifdef DATS_DEBUG
printf("found C\n");
#endif
                    return C;}
"D"                 {
#ifdef DATS_DEBUG
printf("found D\n");
#endif
                     return D;}
"E"                 {
#ifdef DATS_DEBUG
printf("found E\n");i
#endif
                     return E;}
"F"                 {
#ifdef DATS_DEBUG
printf("found F\n");
#endif
                     return F;}
"G"                 {
#ifdef DATS_DEBUG
printf("found G\n");
#endif
                     return G;}
"A"                 {
#ifdef DATS_DEBUG
printf("found A\n");
#endif
                     return A;}
"B"                 {
#ifdef DATS_DEBUG
printf("found B\n");
#endif
                     return B;}

"#"                 {FREQUENCY *= pow(2,1.0/12.0);}
"b"                 {FREQUENCY /= pow(2,1.0/12.0);}

<bpm>[0-9]+(\.[0-9]+)?   {
                    yylval.dddouble = atof(yytext);
                    BEGIN(INITIAL);
#ifdef DATS_DEBUG
printf("found bpm %s\n", yytext);
#endif
		    return BPM_VALUE;}

[0-9]+              {yylval.ddint = atoi(yytext);
                    return VALUE;}

[ \t]+              {/*eats whitespace*/}
\n                  {dats_line++;}
";"                 {return SEMICOLON;}

. {printf("lexer: unknown \'%s\' at line %d\n", yytext, dats_line);}
%%
