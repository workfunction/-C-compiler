CC     = gcc
CFLAGS = -ll
LEX    = flex
OUTPUT = lex.out
INPUT  = input.txt

all: lex.yy.c
	$(CC) $(CFLAGS) -o $(OUTPUT) $<

lex.yy.c: $(wildcard *.l)
	$(LEX) $<

.PHONY: clean
clean:
	rm *.c lex.out

.PHONY: run
run:
	./$(OUTPUT) $(INPUT)