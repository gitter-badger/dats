
BIFLEX = parser.tab.c lex.yy.c
BIFLEXH = parser.tab.h
OBJECTS := $(patsubst %.c, %.o, wav.c $(BIFLEX) dats.c)
CFLAGS = -Wall -Wextra

all : $(BIFLEX) dats
.PHONY : all

$(BIFLEX) $(BIFLEXH): parser.y lexer.l
	bison -d parser.y
	flex lexer.l

$(OBJECTS): %.o : %.c $(wildcard ../include/*.h)
	$(CC) -c -I../include -O3 -DDATS_DEBUG -g $(CFLAGS) -o $@ $<

dats : $(OBJECTS)
	$(CC) $^ -O3 $(CFLAGS) -lm -DDATS_DEBUG -o $@

.PHONY : clean
clean: $(BIFLEX) $(BIFLEXH) dats
	rm -f $^ *.o
