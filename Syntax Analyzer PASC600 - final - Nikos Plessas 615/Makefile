CC = gcc
CFLAGS = -w -g
LIBS = -lfl -lm

parser: lex.yy.c syntax.tab.c syntax.tab.h syntax.y
	$(CC) $(CFLAGS) lex.yy.c syntax.tab.c -o parser $(LIBS)

lex.yy.c: lexical.l syntax.tab.c syntax.tab.h
	flex lexical.l

syntax.tab.c: syntax.y hashtbl.h hashtbl.c
	bison -d -v syntax.y

.PHONY: clean
clean:
	rm parser.tab.*
	rm lex.yy.c
	rm parser
