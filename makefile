CC=g++
L=flex
Y=bison
FILE=yj2483.calc
CFLAGS=-std=c++11

all: calc

$(FILE).cpp $(FILE).tab.h: $(FILE).y
	$(Y) -d $(FILE).y

lex.yy.c: $(FILE).l $(FILE).tab.h
	$(L) $(FILE).l

calc: lex.yy.c $(FILE).tab.c $(FILE).tab.h
	$(CC) $(CFLAGS) -o calc $(FILE).tab.c lex.yy.c

clean: 
	rm -rf calc $(FILE).tab.c lex.yy.c $(FILE).tab.h