%defines
%no-lines

%code requires
{
	#include <string>
}

%{
	#include <stdio.h>
	#include <map>
	void yyerror(char *);
	int yylex(void);
	std::map<std::string,std::int64_t> sym;
%}

%union{
	std::string* strval;
	std::int64_t intval;
}

%token <intval> INTEGER 
%token VARIABLE 
%token QUIT
%token NEWLINE
%left '+' '-' '*'

%type <strval> sexpr VARIABLE
%type <intval> iexpr

%destructor { printf("Cleaning up...\n");delete $$; } <strval>

%%
program:
	| program line
	;
	
line: NEWLINE {printf("> ");}
	| statement NEWLINE {printf("> ");}
	| QUIT NEWLINE { printf("bye!\n"); exit(0); }
	;
	
statement:
	sexpr { 
		auto it = sym.find(*$1);
		if(it != sym.end())
		{
			printf("%d\n",it->second);
			delete $1;
		}
		else
		{
			char buff[256];
			#ifdef _MSC_VER
			sprintf_s
			#else
			sprintf
			#endif
			(buff,"The symbol %s is not defined yet!",$1->c_str());
			delete $1;
			yyerror(buff);
			YYERROR;
		}
	}
	| iexpr { printf("%d\n", $1); }
	| sexpr '=' iexpr {
		std::pair<std::string,std::int64_t> my_pair(*$1,$3);
		delete $1;
		sym.insert(my_pair); }
	;
	
iexpr:
	INTEGER
	| '-' iexpr 
		{ $$ = -$2; }
	| iexpr '+' iexpr
		{ $$ = $1 + $3; }
	| iexpr '-' iexpr { $$ = $1 - $3; }
	| iexpr '*' iexpr { $$ = $1 * $3; }
	| '(' iexpr ')' { $$ = $2; }
	;
	
sexpr:
	VARIABLE { 
		$$ = $1;
	}
	
%%
void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
}
int main(void) {
	printf("> ");
	int ret = 1;
	while(ret)
	{
		ret = yyparse();
		if(ret)
			printf("> ");
	}
}