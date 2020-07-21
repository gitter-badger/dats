#include <stdio.h>
#include <getopt.h>
#include <dlfcn.h>

#include "wav.h"
#include "dats.h"

extern int yyparse();
extern FILE *yyin;

void (*dats_create_pcm)();
void *handle;

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
   printf("size of wav %d bytes. period bpm %f\n",
       2*WAV_ALLOC, WAV_BPM_PERIOD);
#endif

   dlclose(handle);
   fclose(yyin);
   dats_create_wav();

   return 0;

}
