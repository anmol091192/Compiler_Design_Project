OBJ = bison.o lex.o main.o
CC = g++
CFLAGS = -g -Wall -ansi -pedantic -std=gnu++0x

mini_lang:$(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o mini_lang -lfl

lex.o: lex.c
	$(CC) $(CFLAGS) -c lex.c -o lex.o

lex.c: lex_final.l
	flex lex_final.l
	cp lex.yy.c lex.c

bison.o: bison.c
	$(CC) $(CFLAGS) -c bison.c -o bison.o

bison.c: grammar.y
	bison -d -v grammar.y
	cp grammar.tab.c bison.c
	cmp -s grammar.tab.h tok.h || cp grammar.tab.h tok.h

main.o: main.cc
	$(CC) $(CFLAGS) -c main.cc -o main.o

lex.o yac.o main.o: headers.h
lex.o main.o: tok.h


clean:
	rm -f *.o *~ lex.c lex.yy.c bison.c tok.h grammar.tab.c grammar.tab.h grammar.output mini_lang

