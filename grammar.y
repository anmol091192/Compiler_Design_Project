%{

#include "headers.h"
int yyerror(char *s);
int yylex(void);
%}


%union{

int int_value;
string *str_value;
}


%start start_symbol

%token <int_value> INT_LITERAL
%token <str_value> STR_LITERAL
%token PROGRAM BEGINPROGRAM ENDPROGRAM INTEGER WHILE LOOP ARRAY OF IF THEN ELSE ENDIF WRITE READ OR NOT ENDLOOP AND SEMICOLON COMMA COLON TRUE FALSE
%type <int_value> number
%type <str_value> id




%left SUB ADD
%left MULT DIV MOD
%left GT LT EQ GTE LTE NEQ
%left LEFT_PAREN RIGHT_PAREN
%right ASSIGN


%%

start_symbol: program id semicolon rest_of_block endprogram
	           ;

rest_of_block: identifier_decl semicolon more_decl beginprogram statement semicolon more_statements
	           ;

more_decl: /* empty */ 
	           | identifier_decl semicolon more_decl
                   ;


more_statements: /* empty */ 
	           | statement semicolon more_statements
                   ;


identifier_decl: id identifier_decl_2 colon identifier_decl_3 integer
	           ;

identifier_decl_2: /* empty */
		   | comma id identifier_decl_2
                   ;
                
identifier_decl_3: /* empty */
		   | array left_paren number right_paren of 
                   ;


statement: variable assign expression
	          | if condition then statement semicolon loops endif
                  | while condition loop statement semicolon rest_of_statements endloop
                  | read variable variable_more
                  | write variable variable_more
                  ;


 
loops: /* empty */
            | statement semicolon loops
            | else statement semicolon elseloop
            ;
	           
elseloop: /* empty */
	    | statement semicolon elseloop
            ;


rest_of_statements: /* empty */
		    | statement semicolon rest_of_statements
                    ;


variable_more: /* empty */
	       | comma variable variable_more
               ;



condition: relation_and_expression condition_2
               ;


condition_2: /* empty */
	     | or relation_and_expression condition_2
             ;


relation_and_expression: relation_expression relation_and_expression_2
		          ;


relation_and_expression_2: /* empty */
			   | and relation_expression relation_and_expression_2
                           ;



relation_expression: not relation_expression_2
		     | relation_expression_2
                     ;

relation_expression_2: expression compr expression
                       | true
                       | false
                       | left_paren condition right_paren
                       ;



compr: eq 
       | neq
       | lt
       | gt
       | lte
       | gte
        ;


expression: mult_exp expression_2
	    ;

expression_2: /* empty */
	      | add mult_exp expression_2
              | sub mult_exp expression_2
              ;



mult_exp: term mult_exp_2
	  ;

mult_exp_2: /* empty */
	    | mult term mult_exp_2
            | div term mult_exp_2
            | mod term mult_exp_2
            ;

term: sub term_2
      | term_2
      ;


term_2: variable 
        | number
        | left_paren expression right_paren
        ;


variable: id
	  | id left_paren expression right_paren
          ;


id:           STR_LITERAL;  
number:       INT_LITERAL;
program:      PROGRAM;
beginprogram: BEGINPROGRAM;
endprogram:   ENDPROGRAM;
integer:      INTEGER;
of:           OF;
array:        ARRAY;
if:           IF;
then:         THEN;
endif:        ENDIF;
else:         ELSE;
while:        WHILE;
loop:         LOOP;
endloop:      ENDLOOP;
read:         READ;
write:        WRITE;
and:          AND;
or:           OR;
not:          NOT;
true:         TRUE;
false:        FALSE;
sub:          SUB;
add:          ADD;
mult:         MULT;
div:          DIV;
mod:          MOD;
eq:           EQ;
neq:          NEQ;
lt:           LT;
gt:           GT;
lte:          LTE;
gte:          GTE;
semicolon:    SEMICOLON;
colon:        COLON;
comma:        COMMA;
left_paren:   LEFT_PAREN;
right_paren:  RIGHT_PAREN;
assign:       ASSIGN;

%%


int yyerror(string s)
{
      extern int yylineno;
      extern char *yytext;
      cerr << "ERROR:"<< s << " occured at symbol \"" << yytext;
      cerr << "\" on line no " << yylineno << endl;
      exit(1);
}


int yyerror(char *s)
{

      return yyerror(string(s));
}
