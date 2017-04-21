CC     = gcc
CFLAGS = -ll -g
LEX    = flex
OUTPUT = lex.out
BASIC  = $(PWD)/input_case/basic/*.txt
ADV	   = $(PWD)/input_case/advence/*.txt

$(OUTPUT): lex.yy.c
	$(CC) $(CFLAGS) -o $(OUTPUT) $<

lex.yy.c: $(wildcard *.l)
	$(LEX) $<

.PHONY: clean
clean:
	rm *.c lex.out

run: $(OUTPUT)
	./$(OUTPUT) $(BASIC)
	./$(OUTPUT) $(ADV)
