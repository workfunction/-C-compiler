CC     = gcc
CFLAGS = -ll
LEX    = flex
OUTPUT = lex.out
INPUT  = $(PWD)/input_case/basic/*.txt

$(OUTPUT): lex.yy.c
	$(CC) $(CFLAGS) -o $(OUTPUT) $<

lex.yy.c: $(wildcard *.l)
	$(LEX) $<

.PHONY: clean
clean:
	rm *.c lex.out

run: $(OUTPUT)
	./$(OUTPUT) $(INPUT)