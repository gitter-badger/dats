
BIFLEX = parser.tab.c parser.tab.h lex.yy.c
OBJECTS := $(patsubst %.c, %.o, wav.c parser.tab.c lex.yy.c)
CFLAGS = -Wall -Wextra -Wtraditional

all : $(BIFLEX) dats
.PHONY : all

$(BIFLEX) : parser.y lexer.l
	bison -d parser.y
	flex lexer.l

$(OBJECTS): %.o : %.c $(wildcard ../include/*.h)
	$(CC) -c -I../include -O3 $(CFLAGS) -o $@ $<

dats : $(OBJECTS)
	$(CC) $^ -O3 $(CFLAGS) -lm -o $@

.PHONY : clean
clean: $(OBJECTS) $(BIFLEX) dats
	rm -f $^
