 /* calculator */
%option nounistd
%option interactive
%option noyywrap
%option reentrant
%option extra-type="ParseContext*"
%option bison-bridge
%{
	#include <string>
	#include "parsecontext.h"
	#include "calculator.tab.h"
	#include <stdlib.h>
	void yyerror(ParseContext*,const char *);
	int isatty(int fd) {return 1;}
	
	#ifdef _MSC_VER
	#define fileno _fileno
	#endif
%}

%%
exit|quit { return QUIT; }

[a-zA-Z]+ {
	yylval->strval = new std::string(yytext);
	return VARIABLE;
}

[0-9]+ {
	yylval->intval = atoi(yytext);
	return INTEGER;
}

[\r]?\n {return NEWLINE; }

[-+()=*] { return *yytext; }

[ \t] ; /* skip whitespace */

. yyerror(yyextra,"Unknown character");

%%

ParseContext::ParseContext()
{
	yylex_init(&scanner);
	yyset_extra(this, scanner);
}

ParseContext::~ParseContext()
{
	yylex_destroy(scanner);
}

// int yywrap(void) {
	// return 1;
// }