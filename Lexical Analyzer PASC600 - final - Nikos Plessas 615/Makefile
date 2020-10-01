CC = gcc
CFLAGS = -w -g
LIBS = -lfl -lm

lexer: lex.yy.c 
	$(CC) $(CFLAGS) lex.yy.c -o lexer $(LIBS)

lex.yy.c: lexical.l
	flex lexical.l


.PHONY: clean
clean:
	rm lex.yy.c
	rm parser
