#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>

//fine DEFINE_WAV_VARIABLES
#include "wav.h"

#include "plugh.h"

#if 0
struct plugin_info {
   char author[50];
   char plugin_name[50];
   char plugin_version[15];
};
#endif
struct plugin_info stdpsg = {
   .author = "Al-buharie Amjari",
   .plugin_name = "psg",
   .plugin_version = "1.0.0"

};

void sine(void){
   static uint32_t i = 0;
   auto size_t b = 0;

   if (raw_pcm == NULL) {
      fprintf(stderr, "allocating sound failed\n");
      exit(1);
   }

   double periodw = (double) 1.0/WAV_SAMPLE_RATE;

   for (; i < WAV_ALLOC; i++, b++){
      raw_pcm[i] = (int16_t)(10000.0*sin(2.0*FREQUENCY*M_PI*periodw*b));
   }
   printf("raw_pcm: %p\n", raw_pcm);
}
