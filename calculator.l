 /* calculator */
%option nounistd
%option interactive

%{
	#include "calculator.tab.h"
	#include <stdlib.h>
	void yyerror(char *);
	int isatty(int fd) {return 1;}
	
	#ifdef _MSC_VER
	#define fileno _fileno
	#endif
%}

%%
[a-zA-Z] {
	yylval = *yytext;
	return VARIABLE;
}

[0-9]+ {
	yylval = atoi(yytext);
	return INTEGER;
}

[\r]?\n {return NEWLINE; }

[-+()=*] { return *yytext; }

[ \t] ; /* skip whitespace */

exit|quit { return QUIT; }



. yyerror("Unknown character");

%%

int yywrap(void) {
	return 1;
}