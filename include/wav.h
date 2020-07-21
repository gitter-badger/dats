
#ifdef DEFINE_WAV_VARIABLES
#define EXTERN
#else
#define EXTERN extern
#endif

#ifndef DATS_WAV
#define DATS_WAV

typedef struct __attribute__((__packed__)) {
   char     ChunkID[4];
   uint32_t ChunkSize;
   char     Format[4];
   char     Subchunk1ID[4];
   uint32_t Subchunk1Size;
   uint16_t AudioFormat;
   uint16_t NumChannels;
   uint32_t SampleRate;
   uint32_t ByteRate;
   uint16_t BlockAlign;
   uint16_t BitsPerSample;
   char     Subchunk2ID[4];
   uint32_t Subchunk2Size;

} wav_header_struct;

extern int dats_create_wav(void);

EXTERN int16_t *raw_pcm;


EXTERN double    WAV_BPM;
EXTERN double    FREQUENCY;
EXTERN double    WAV_BPM_PERIOD;
EXTERN uint32_t  WAV_ALLOC;
EXTERN uint32_t  WAV_SAMPLE_RATE;
EXTERN uint32_t  WAV_TIME;


#endif
