%{

#include <stdio.h>
#include "lex.c"

void yyerror(char*);
%}

%token INT FLOAT FUNCTION_BLOCK VAR_INPUT REAL END_VAR VAR_OUTPUT FUZZIFY TERM IGUAL END_FUZZIFY  DEFUZZIFY  END_DEFUZZIFY  IDENTIFIER  TAB  IF
%token IS  AND	 OR	 THEN	 END	 END_RULEBLOCK  END_FUNCTION_BLOCK  METHOD  COG  MIN  MAX ACT  ACCU  RULE RULEBLOCK DEFAULT

%start inicio_expressao

%%
inicio_expressao: FUNCTION_BLOCK {printf("Function Block");} IDENTIFIER {printf("IDENTIFIER");} declaracao_variavel {printf("IDENTIFIER");} fuzzify defuzzify ruleblock END_FUNCTION_BLOCK { printf("Inicio do programa");};

declaracao_variavel: VAR_INPUT {printf("VAR INPUT");} variavel  {printf("VARIAVEL");}
		   | VAR_OUTPUT '\n' '\t' variavel;

variavel: IDENTIFIER ':' REAL ';' 
	| IDENTIFIER ':' REAL ';' '\n' '\t' variavel;

fuzzify: FUZZIFY IDENTIFIER '\n' '\t' term END_FUZZIFY;

term: TERM IDENTIFIER IGUAL '(' INT ',' INT ')' ';'
    | TERM IDENTIFIER IGUAL '(' INT ',' INT ')' ';' '\n' '\t' term;

defuzzify: DEFUZZIFY IDENTIFIER '\n' '\t' term END_DEFUZZIFY
	 | DEFUZZIFY IDENTIFIER '\n' '\t' term '\n' '\t' method END_DEFUZZIFY
	 | DEFUZZIFY IDENTIFIER '\n' '\t' term '\n' '\t' method '\n' '\t' default END_DEFUZZIFY
	 | DEFUZZIFY IDENTIFIER '\n' '\t' term '\n' '\t' default END_DEFUZZIFY;

method: METHOD ':' COG';'
      | METHOD ':' COG';' '\n' '\t' method;

default: DEFAULT ':' INT';'
       | DEFAULT ':' INT';' '\n' '\t' default;

ruleblock: RULEBLOCK IDENTIFIER '\n' '\t' complemento END_RULEBLOCK;

complemento: and | and complemento | act | act complemento | accu | accu complemento | rule | rule complemento;

and: AND ':' MIN';' | AND ':' MAX';';

act: ACT ':' MIN';' | ACT ':' MAX';';

accu: ACCU ':' MIN';' | ACCU ':' MAX';';

rule: RULE INT ':' IF IDENTIFIER IS IDENTIFIER OR IDENTIFIER IS IDENTIFIER THEN IDENTIFIER IS IDENTIFIER
    | RULE INT ':' IF IDENTIFIER IS IDENTIFIER AND IDENTIFIER IS IDENTIFIER THEN IDENTIFIER IS IDENTIFIER
    | RULE INT ':' IF IDENTIFIER IS IDENTIFIER THEN IDENTIFIER IS IDENTIFIER;


%%


extern char *yytext;
extern int column;

void yyerror(s)
char *s;
{
	fflush(stdout);
	printf("\n%*s\n%*s\n", coluna, "^", coluna, s);
}


int main()
{
  yyin = fopen("fuzzy.fcl","r");
  return(yyparse());
}


