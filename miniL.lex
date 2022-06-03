   /* cs152-miniL phase1 */
   
%{ 
   #include "y.tab.h"  
   /* write your C code here for definitions of variables and including headers */
   int currLine, currPos = 1;
%}

   /* some common rules */
LETTER [a-z|A-Z]
DIGIT [0-9]
COMMENT ##.*\n
%%
   /* specific lexer rules in regex */


"("	{currPos += yyleng; return L_PAREN;}
")"	{currPos += yyleng; return R_PAREN;}
":"	{currPos += yyleng; return COLON;}
"["	{currPos += yyleng; return L_SQUARE_BRACKET;}
"]"	{currPos += yyleng; return R_SQUARE_BRACKET;}
":="	{currPos += yyleng; return ASSIGN;}
"or"	{currPos += yyleng; return OR;}
"and"	{currPos += yyleng; return AND;}
"not"	{currPos += yyleng; return NOT;}
"true"	{currPos += yyleng; return TRUE;}
"false"	{currPos += yyleng; return FALSE;}
"function"	{currPos += yyleng; return FUNCTION;}
"beginparams"	{currPos += yyleng; return BEGIN_PARAMS;}
"endparams"	{currPos += yyleng; return END_PARAMS;}
"beginlocals"	{currPos += yyleng; return BEGIN_LOCALS;}
"endlocals"	{currPos += yyleng; return END_LOCALS;}
"beginbody"	{currPos += yyleng; return BEGIN_BODY;}
"endbody"	{currPos += yyleng; return END_BODY;}
"integer"	{currPos += yyleng; return INTEGER;}
"array"	{currPos += yyleng; return ARRAY;}
"enum"	{currPos += yyleng; return ENUM;}
"of"	{currPos += yyleng; return OF;}
"if"	{currPos += yyleng; return IF;}
"then"	{currPos += yyleng; return THEN;}
"endif"	{currPos += yyleng; return ENDIF;}
"else"	{currPos += yyleng; return ELSE;}
"for"	{currPos += yyleng; return FOR;}
"while"	{currPos += yyleng; return WHILE;}
"do"	{currPos += yyleng; return DO;}
"beginloop"	{currPos += yyleng; return BEGINLOOP;}
"endloop"	{currPos += yyleng; return ENDLOOP;}
"continue"	{currPos += yyleng; return CONTINUE;}
"read"	{currPos += yyleng; return READ;}
"write"	{currPos += yyleng; return WRITE;}
"return"	{currPos += yyleng; return RETURN;}
"=="	{currPos += yyleng; return EQ;}
"<="	{currPos += yyleng; return LTE;}
">="	{currPos += yyleng; return GTE;}
"<>"	{currPos += yyleng; return NEQ;}
">"	{currPos += yyleng; return GT;}
"<"	{currPos += yyleng;return LT;}
"+"	{currPos += yyleng; return ADD;}
"-"	{currPos += yyleng; return SUB;}
"*"	{currPos += yyleng; return MULT;}
"/"	{currPos += yyleng; return DIV;}
"%"	{currPos += yyleng; return MOD;}
","	{currPos += yyleng; return COMMA;}
";"	{currPos += yyleng; return SEMICOLON;}
{DIGIT}+	{currPos += yyleng; /*yylval.num = atoi(yytext) */ return NUMBER;}
[ \t]+	{currPos += yyleng;}
{COMMENT} {currLine++; currPos = 1;}
{LETTER}|{LETTER}({LETTER}|{DIGIT}|_)*({LETTER}|{DIGIT})	{currPos += yyleng; /*yylval.ident = yytext;*/ return IDENT;}
({DIGIT}|_)({LETTER}|{DIGIT}|_)*({LETTER}|{DIGIT})	{printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", currLine, currPos, yytext); exit(0);}
{LETTER}({LETTER}|{DIGIT}|_)*(_)	{printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", currLine, currPos, yytext); exit(0);}
"\n"	{currLine++; currPos = 1;}

.	{printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", currLine, currPos, yytext); exit(0);}
%%
	/* C functions used in lexer */

/*
int main(int argc, char ** argv)
{
   if(argc >= 2){
      yyin = fopen(argv[1], "r");
      if(yyin == NULL){
         yyin = stdin;
      }
   }else{
      yyin = stdin;
   }

   yylex();
}
*/
