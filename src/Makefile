
BIFLEX = dats.tab.c dats.tab.h lex.yy.c
OBJECTS := $(patsubst %.c, %.o, wav.c dats.tab.c lex.yy.c) 

all : $(BIFLEX) dats
.PHONY : all

$(BIFLEX) : dats.y dats.l
	bison -d dats.y
	flex dats.l

$(OBJECTS): %.o : %.c $(wildcard ../include/*.h)
	$(CC) -c -I../include -O3 -o $@ $<

dats : $(OBJECTS)
	$(CC) -o $@ $^ -O3 -lm

.PHONY : clean
clean: $(OBJECTS) $(BIFLEX) dats
	rm -f $^
