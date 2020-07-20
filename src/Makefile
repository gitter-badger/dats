CC = gcc
OBJ := $(patsubst %.c, %.o, $(wildcard *.c))
BIFLEX = dats.tab.c dats.tab.h lex.yy.c

all : $(BIFLEX) $(OBJ) dats
.PHONY : all

$(BIFLEX) : dats.y dats.l
	bison -d dats.y
	flex dats.l

$(OBJ): %.o : %.c ../include/wav.h ../include/notes.h
	$(CC) -c -I../include -O3 -o $@ $<

dats : $(OBJ)
	$(CC) -o $@ $^ -O3 -lm

.PHONY : clean
clean: $(OBJ) $(BIFLEX) dats
	rm -f $^
