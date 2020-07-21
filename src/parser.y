%define parse.error verbose
%locations

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
#include <dlfcn.h>

#define DEFINE_WAV_VARIABLES
#include "wav.h"
#include "dats.h"

extern int yylex();

void dats_clean(void);
int yyerror(const char *s);

static int bpm_flag;

#if 0
double    WAV_BPM;
double    FREQUENCY;
double    WAV_BPM_PERIOD;
uint32_t  WAV_SAMPLE_RATE;
uint32_t  WAV_ALLOC;

int16_t *raw_pcm;

#endif
%}

%union {
   double dddouble;
   int ddint;
}

%token BEG BPM NOTE END
%token C D E F G A B
%token USE LIB FUNC

%token <ddint> VALUE
%token <dddouble> BPM_VALUE
%token SEMICOLON

%start S

%%
S : prerequisite BEG notes END
 ;
prerequisite : {
printf("warning: using sine from libpsg\n");
handle = dlopen("../plugins/libpsg.so", RTLD_NOW);
if (!handle) {
   fprintf(stderr, "%s\n",
   dlerror());
   exit(1);
}
*(void**)(&dats_create_pcm) = dlsym(handle, "sine");
if (!dats_create_pcm) {
   fprintf(stderr, "%s\n",
   dlerror());
   exit(1);
}
}
 | USE LIB FUNC
 ;
notes : bpm NOTE note_length note_key octave SEMICOLON {dats_create_pcm();}
 | notes bpm NOTE note_length note_key octave SEMICOLON {dats_create_pcm();}
 ;
bpm : {
if (bpm_flag == 0) {
   printf("warning; BPM is set to 120\n");
   WAV_BPM        = 120;
   WAV_BPM_PERIOD = 60.0*WAV_SAMPLE_RATE/WAV_BPM;
   bpm_flag = 1;
} 
;}
 | BPM BPM_VALUE SEMICOLON {
WAV_BPM        = $2;
WAV_BPM_PERIOD = 60.0*WAV_SAMPLE_RATE/WAV_BPM;
bpm_flag = 1;}
 ;
note_length : VALUE {
WAV_ALLOC += WAV_BPM_PERIOD*4/(double)$1;
raw_pcm    = realloc(raw_pcm, sizeof(int16_t)*WAV_ALLOC);
printf("parser raw_pcm: %p\n", raw_pcm);
#ifdef DATS_DEBUG
printf("nl %d at line", $1);
#endif
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
 ;
%%


int yyerror(const char *s){
   fprintf(stderr, "parser: %s\n", s);
   dats_clean();
   exit(1);
}

void dats_clean(void){
   free(raw_pcm);
}
