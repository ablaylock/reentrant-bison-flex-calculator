 /* calculator */
%option nounistd
%option interactive

%{
	#include <string>
	#include "calculator.tab.h"
	#include <stdlib.h>
	void yyerror(char *);
	int isatty(int fd) {return 1;}
	
	#ifdef _MSC_VER
	#define fileno _fileno
	#endif
%}

%%
exit|quit { return QUIT; }

[a-zA-Z]+ {
	yylval.strval = new std::string(yytext);
	return VARIABLE;
}

[0-9]+ {
	yylval.intval = atoi(yytext);
	return INTEGER;
}

[\r]?\n {return NEWLINE; }

[-+()=*] { return *yytext; }

[ \t] ; /* skip whitespace */

. yyerror("Unknown character");

%%

int yywrap(void) {
	return 1;
}