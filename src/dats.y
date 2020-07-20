%define parse.error verbose
%{
/*  Copyright (c) 2020 Al-buharie Amjari <healer.harie@gmail.com>
 *
 *  This file is part of Dats.
 *
 *  Dats is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Dats is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Dats.  If not, see <https://www.gnu.org/licenses/>.
 */

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>

#include "notes.h"
#include "wav.h"

extern FILE *yyin;
extern int yylex();
extern int yyparse();
extern uint32_t dats_line;

void dats_clean(void);
int yyerror(const char *s);
int bpm_flag;

double    WAV_BPM;
double    FREQUENCY;
double    WAV_BPM_PERIOD;
uint32_t  WAV_SAMPLE_RATE;
uint32_t  WAV_ALLOC;

int16_t *raw_PCM;
%}

%union {
   double dddouble;
   int ddint;
}

%token BEG BPM NOTE END
%token C D E F G A B 

%token <ddint> VALUE
%token <dddouble> BPM_VALUE
%token NL_1 NL_2 NL_4 NL_8 NL_16
%token SEMICOLON

%start S

%%
S : BEG notes END
 ;
notes : bpm NOTE note_length note_key octave SEMICOLON {dats_construct_pcm(0);}
 | notes bpm NOTE note_length note_key octave SEMICOLON {dats_construct_pcm(0);}
 ;
bpm : {
if (bpm_flag == 0) {
   printf("warning; BPM is set to 120\n");
   WAV_BPM = 120;
   WAV_BPM_PERIOD = 60.0*WAV_SAMPLE_RATE/WAV_BPM;
} 
bpm_flag = 1;}
 | BPM BPM_VALUE SEMICOLON {
WAV_BPM = $2;
WAV_BPM_PERIOD = 60.0*WAV_SAMPLE_RATE/WAV_BPM;
bpm_flag = 1;}
 ;
note_length : VALUE {
WAV_ALLOC += WAV_BPM_PERIOD*4/(double)$1;
raw_PCM = realloc(raw_PCM, sizeof(int16_t)*WAV_ALLOC);
#ifdef DATS_DEBUG
printf("nl %d at line %d\n", $1, dats_line);
#endif /*DATS_DEBUG*/
}
 ;
note_key : C {FREQUENCY = 16.35159783;}
 | D {FREQUENCY = 18.35404799;}
 | E {FREQUENCY = 20.60172231;}
 | F {FREQUENCY = 21.82676446;}
 | G {FREQUENCY = 24.49971475;}
 | A {FREQUENCY = 27.50;}
 | B {FREQUENCY = 30.86770633;}
 ;
octave : VALUE {FREQUENCY *= pow(2, $1);}
%%

int main(int argc, char *argv[]){

 
   if (argc < 2) {
      yyin = stdin;
      goto parse;

   }

   if (!(yyin = fopen(argv[1], "r"))) {
      perror(argv[1]);
      return 1;

   }

   parse:
   WAV_SAMPLE_RATE = 44100;
   yyparse();

#ifdef DATS_DEBUG   
   printf("size of wav %d bytes. period bpm %f\n", 2*WAV_ALLOC, WAV_BPM_PERIOD);
#endif

   fclose(yyin);
   dats_create_wav();

   return 0;
}

int yyerror(const char *s){
   fprintf(stderr, "parser: %s at line %d\n", s, dats_line);
   dats_clean();
   exit(1);
}

void dats_clean(void){
   free(raw_PCM);
}
