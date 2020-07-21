#include <stdio.h>
#include <math.h>
#include <stdint.h>

#define DEFINE_WAV_VARIABLES
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

int sine(){
   static uint32_t i = 0;
   auto size_t b = 0;

   if (raw_pcm == NULL) {
      fprintf(stderr, "allocating sound failed\n");
      exit(1);
   }

   double periodw = (double) 1.0/WAV_SAMPLE_RATE;

   for (; i < WAV_ALLOC; i++, b++){
      raw_pcm[i] = (pow(M_E, -b*periodw*3)*23000.0*sin(2.0*M_PI*
      FREQUENCY*b*periodw))+pow(M_E, -b*periodw*3)*10000.0*
      cos(M_PI*FREQUENCY*(b+1.8)*periodw);
   }
}
