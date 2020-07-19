%option noyywrap

%{
#include <stdio.h>
#include <stdint.h>
#include <math.h>

#include "dats.tab.h"
#include "notes.h"

#define YY_DECL int yylex()
uint32_t dats_line = 1;
%}

%s bpm

%%

(\/\/).*            {/* comment */}
"BPM"               {BEGIN(bpm); return BPM;}
"BEGIN"             {return BEG;}
"END"               {return END;}
"NOTE"              {return NOTE;}

"C"                 {printf("found C\n");
                    return C;}
"D"                 {printf("found D\n");
                     return D;}
"E"                 {printf("found E\n");
                     return E;}
"F"                 {printf("found F\n");
                     return F;}
"G"                 {printf("found G\n");
                     return G;}
"A"                 {printf("found A\n");
                     return A;}
"B"                 {printf("found B\n");
                     return B;}

"#"                 {FREQUENCY *= pow(2,1.0/12.0);}
"b"                 {FREQUENCY /= pow(2,1.0/12.0);}

<bpm>[0-9]+(\.[0-9]+)?   {
                    yylval.dddouble = atof(yytext);
                    BEGIN(INITIAL);
                    printf("found bpm %s\n", yytext);
		    return BPM_VALUE;}

[0-9]+              {yylval.ddint = atoi(yytext);
                    return VALUE;}

[ \t]+              {/*eats whitespace*/}
\n                  {dats_line++;}
";"                 {return SEMICOLON;}

. {printf("lexer: unknown \'%s\' at line %d\n", yytext, dats_line);}
%%
