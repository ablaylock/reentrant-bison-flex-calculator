%defines
%no-lines

%{
	#include <stdio.h>
	#include <map>
	void yyerror(char *);
	int yylex(void);
	std::map<char,int> sym;
%}

%token INTEGER 
%token VARIABLE 
%token QUIT
%token NEWLINE
%left '+' '-' '*'

%%
program:
	| program line
	;
	
line: NEWLINE
	| statement NEWLINE
	| QUIT NEWLINE { printf("bye!\n"); exit(0); }
	;
	
statement:
	expression { printf("%d\n", $1); }
	| VARIABLE '=' expression {
		std::pair<char,int> my_pair($1,$3);
		sym.insert(my_pair); }
	;
	
expression:
	INTEGER
	| 
	| VARIABLE { 
	auto it = sym.find($1);
	if(it != sym.end())
		$$ = it->second;
	else
	{
		char buff[256];
		sprintf_s(buff,"The symbol %c is not defined yet!",$1);
		yyerror(buff);
		return 1;
	}
	}
	| '-' expression { $$ = -$2; }
	| expression '+' expression { $$ = $1 + $3; }
	| expression '-' expression { $$ = $1 - $3; }
	| expression '*' expression { $$ = $1 * $3; }
	| '(' expression ')' { $$ = $2; }
	;
%%
void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
}
int main(void) {
	yyparse();
}