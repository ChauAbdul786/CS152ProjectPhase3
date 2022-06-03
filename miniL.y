%{
#include <stdio.h>
extern FILE * yyin;
extern int currLine;
extern int currPos;
 
void yyerror(const char * msg) {
	printf("Error: On line %d, column %d: %s \n", currLine, currPos, msg);
}
%}

%union 
{
    char* id;
    int num;
}

%error-verbose

%start Program

%token <num> NUMBER

%token <id> IDENT

%token L_PAREN 
%token R_PAREN 
%token COLON 
%token L_SQUARE_BRACKET 
%token R_SQUARE_BRACKET
%left ASSIGN
%left AND
%left OR
%right NOT 
%token TRUE 
%token FALSE 
%token FUNCTION 
%token BEGIN_PARAMS 
%token END_PARAMS
%token BEGIN_LOCALS 
%token END_LOCALS 
%token BEGIN_BODY 
%token END_BODY 
%token INTEGER 
%token ARRAY 
%token ENUM 		
%token OF 
%token IF 
%token THEN 
%token ENDIF 
%token ELSE 
%token FOR
%token WHILE 
%token DO 
%token BEGINLOOP 
%token ENDLOOP
%token CONTINUE 
%token READ 
%token WRITE 
%token RETURN
%left EQ
%left LTE
%left GTE
%left NEQ
%left GT
%left LT
%left ADD
%left SUB
%left MULT
%left DIV
%left MOD
%token COMMA
%token SEMICOLON 

%%

Program:
	 functions 
	 {printf("Program -> functions\n");}

functions: 
	 function functions {printf("functions -> fx functions\n");} 
	| %empty {printf("functions -> epsilon\n");}

function: 	
	FUNCTION id SEMICOLON BEGIN_PARAMS decs END_PARAMS BEGIN_LOCALS decs END_LOCALS BEGIN_BODY statements END_BODY 
	{printf("fx -> FUNCTION id SEMICOLON BEGIN_PARAMS decs END_PARAMS BEGIN_LOCALS decs END_LOCALS BEGIN_BODY statements END_BODY\n");}

decs:
	 dec SEMICOLON decs {printf("decs -> dec SEMICOLON decs\n");} 
	| %empty {printf("decs -> epsilon\n");}

dec: 
	ids COLON INTEGER {printf("dec -> ids COLON INTEGER\n");} 
	| ids COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER {printf("dec -> ids COLON ARRAY L_SQUARE_BRACKET NUMBER  R_SQUARE_BRACKET OF INTEGER\n");}
	| ENUM L_PAREN ids  R_PAREN {printf("dec -> ENUM L_PAREN ids R_PAREN\n");} 

ids: 
	id {printf("ids -> id\n");} 
	| id COMMA ids {printf("ids -> id COMMA ids\n");}

id: 
	IDENT {printf("id -> IDENT %s\n", $1);}

statements: 
	statement SEMICOLON statements {printf("statements -> statement SEMICOLON statements\n");} 
	| statement SEMICOLON {printf("statements -> statement SEMICOLON\n");}

statement: 
	st_var {printf("statement -> st_var\n");}
	| st_if {printf("statement -> st_if\n");} 
	| st_while {printf("statement -> st_while\n");} 
	| st_do {printf("statement -> st_do\n");} 
	| st_read {printf("statement -> st_read\n");} 
	| st_write {printf("statement -> st_write\n");} 
	| st_continue {printf("statement -> st_continue\n");}  
	| st_return {printf("statement -> st_return\n");} 

st_var:
        x ASSIGN expression {printf("st_var -> x ASSIGN expression\n");} 

st_if:
        IF bool_exp THEN statements ENDIF {printf("st_if -> IF bool_exp THEN statements ENDIF\n");} 

st_while:
        WHILE bool_exp BEGINLOOP statements ENDLOOP {printf("st_while -> WHILE bool_exp BEGINLOOP statements ENDLOOP\n");} 

st_do:
        DO BEGINLOOP statements ENDLOOP {printf("st_do -> DO BEGINLOOP statements ENDLOOP\n");} 

st_read:
        READ x  {printf("st_read -> READ x SEMICOLON\n");}

st_write: 
        WRITE x  {printf("st_write -> WRITE x SEMICOLON\n");}

st_continue: 
        CONTINUE {printf("st_continue -> CONTINUE\n");}

st_return: 
	RETURN expression {printf("st_return -> RETURN expression\n");} 

bool_exp: 
	relationandexp {printf("bool_exp -> relationandexp");}
	| relationandexp OR bool_exp {printf("bool_exp -> relationandexpression OR bool_exp\n");}

relationandexp:
	relationexp {printf("relationandexpression -> relationexp");}
	| relationexp AND relationandexp {printf("relationexp AND relationandexp");}

relationexp:
	notexp exp_comp {printf("relation_exp -> notexp exp_comp\n");}
	| notexp TRUE  {printf("relation_exp -> notexp TRUE\n");}
	| notexp FALSE  {printf("relation_exp -> notexp FALSE\n");}
	| notexp L_PAREN bool_exp R_PAREN  {printf("relation_exp -> notexp L_PAREN bool_exp R_PAREN\n");}

notexp:
	NOT {printf("notexp -> NOT");}
	| %empty {printf("notexp -> epsilon");}

exp_comp:
	 expression comp expression {printf("exp_comp -> expression comp expression\n");} 

comp: 
	EQ {printf("comp -> EQ\n");}
	| NEQ {printf("comp -> NEQ\n");}
	| LT {printf("comp -> LT\n");}
	| GT {printf("comp -> GT\n");}
	| LTE {printf("comp -> LTE\n");}
	| GTE {printf("comp -> GTE\n");}

expressions:
	expression COMMA expressions {printf("expressions -> expression COMMA expressions");}
	| %empty {printf("expressions -> epsilon");}

expression:
	 multiplicative_exp add_sub_exp {printf("expression -> multiplicative_exp add_sub_exp\n");}

add_sub_exp:
	ADD expression {printf("add_sub_exp -> ADD expression\n");}
	| SUB expression {printf("add_sub_exp -> SUB expression\n");}
	|  %empty {printf("add_sub_exp -> epsilon\n");}

multiplicative_exp:
	term {printf("multiplicative_exp -> term\n");}
	| term MULT multiplicative_exp {printf("multiplicative_exp -> term MULT multiplicative_exp\n");}
	| term DIV multiplicative_exp {printf("multiplicative_exp -> term DIV multiplicative_exp\n");}
	| term MOD multiplicative_exp {printf("multiplicative_exp -> term MOD multiplicative_exp\n");}

term: 
	minusexp x {printf("term -> minusexp x\n");}
	| minusexp NUMBER {printf("term -> minusexp number\n");}
	| minusexp L_PAREN expression R_PAREN {printf("term -> minusexp L_PAREN expression R_PAREN\n");}
	| id L_PAREN expressions R_PAREN {printf("term -> id L_PAREN expressions R_PAREN\n");} 

minusexp: 
	SUB {printf("minusexp -> SUB");}
	| %empty {printf("minusexp -> epsilon");}

x:
	id {printf("x -> id\n");}
	| id L_SQUARE_BRACKET expression R_SQUARE_BRACKET {printf("x -> id L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n");}

%%

int main(int argc, char ** argv) {
	if (argc >= 2) {
		yyin = fopen(argv[1], "r");
		if (yyin == NULL) {
			yyin = stdin;
		}
	}
	else {
		yyin = stdin;
	}
	yyparse();
	return 1;
}
