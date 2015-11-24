calculator.exe: lex.yy.cpp calculator.tab.cpp calculator.tab.h
	g++ -g -o calculator lex.yy.cpp calculator.tab.cpp -std=gnu++11


calculator.tab.cpp lex.yy.cpp: lex.yy.c calculator.tab.c
	sed -e 's/lex.yy.c/lex.yy.cpp/g' lex.yy.c > lex.yy.cpp
	sed -e 's/calculator.tab.c/calculator.tab.cpp/g' calculator.tab.c  > calculator.tab.cpp
	
lex.yy.c: calculator.l
	flex calculator.l


calculator.tab.c calculator.tab.h: calculator.y
	bison calculator.y


.PHONY: clean
clean:
	rm -f *.exe *.o
	rm *.tab.* lex.*.c
