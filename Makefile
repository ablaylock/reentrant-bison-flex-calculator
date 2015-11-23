calculator.exe: lex.yy.c calculator.tab.c calculator.tab.h
	g++ -g -o calculator lex.yy.c calculator.tab.c

lex.yy.c: calculator.l
	flex calculator.l


calculator.tab.c calculator.tab.h: calculator.y
	bison calculator.y


.PHONY: clean
clean:
	rm -f *.exe *.o
	rm *.tab.* lex.*.c
