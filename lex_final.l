%{
    #include "headers.h"
    #include "tok.h"
    int yyerror(char *s);
%}


LETTER [a-zA-Z]
DIGIT  [0-9]

ID ({LETTER}|{LETTER}({LETTER}|"_"|{DIGIT})*({LETTER}|{DIGIT}))
NUMERAL {DIGIT}+

ID_BEGIN_DIGIT ({DIGIT}|"_")+{ID}+
ID_END_UNDERSCORE {ID}+"_"

%%

"+"                        { return ADD; }
"-"                        { return SUB; }
"*"                        { return MULT;}
"/"                        { return DIV; }
"%"                        { return MOD; }


"<"                        { return LT; }
">"                        { return GT; }
"=="                       { return EQ; }
"<="                       { return LTE;}
">="                       { return GTE;}
"<>"                       { return NEQ;}


"program"                  { return PROGRAM; }
"beginprogram"             { return BEGINPROGRAM; }
"endprogram"               { return ENDPROGRAM; }
"integer"                  { return INTEGER; }
"array"                    { return ARRAY;  }
"of"                       { return OF; }
"if"                       { return IF; }
"then"                     { return THEN; }
"endif"                    { return ENDIF; }
"else"                     { return ELSE; }
"while"                    { return WHILE; }
"loop"                     { return LOOP; }
"endloop"                  { return ENDLOOP; }
"read"                     { return READ; }
"write"                    { return WRITE; }
"and"                      { return AND; }
"or"                       { return OR; }
"not"                      { return NOT; }
"true"                     { return TRUE; }
"false"                    { return FALSE; }


";"                        { return SEMICOLON; }
":"                        { return COLON; }
","                        { return COMMA; }
"("                        { return LEFT_PAREN; }
")"                        { return RIGHT_PAREN; }
":="                       { return ASSIGN; }
"##"[^\n]*                 /*ignore comments*/
[ \r\t]                    /*do nothing*/
[\n]                       { yylineno++; }


{ID}                      { yylval.str_value=new std::string(yytext); return STR_LITERAL;}

{NUMERAL}                 { yylval.int_value = atoi(yytext); return INT_LITERAL;}

.|{ID_BEGIN_DIGIT}|{ID_END_UNDERSCORE}      { std::cerr << "SCANNER"; yyerror(""); exit(1); }

                        
%%




