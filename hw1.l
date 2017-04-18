%{
        #include <stdio.h>
        #include <stdlib.h>
        #include <ctype.h>

        int VAR = 0;
%}

letter    [a-zA-Z] 
digit     [0-9] 
symbol    {letter}+({letter}|{digit})* 
number    {digit}+
double    {digit}*\.{digit}+

%x COMMENT
%x QUOTATION
%x TYPEI
%x TYPED

%%

[\t ]           {}
"int"           {BEGIN(TYPEI);}
<TYPEI>[\t ]    {}
<TYPEI>{symbol} {printf("%s\tint TYPE VAR\n", yytext);BEGIN(INITIAL);}
"double"        {BEGIN(TYPED);}
<TYPED>[\t ]    {}
<TYPED>{symbol} {printf("%s\tdouble TYPE VAR\n", yytext);BEGIN(INITIAL);}
"print"         {printf("%s\tPRINT FUNCTIONN\n",yytext);}
"if"            {printf("%s\tIF FUNCTIONN\n",yytext);}
"else"          {printf("%s\tELSE FUNCTIONN\n",yytext);}
"while"         {printf("%s\tWHILE FUNCTIONN\n",yytext);}

","             {printf("%s\tCOMMA\n",yytext);}
";"             {printf("%s\tSEMICOLON\n",yytext); }
"("             {printf("%s\tLB\n",yytext);}
")"             {printf("%s\tRB\n",yytext);}
"{"             {printf("%s\tLCB\n",yytext);}
"}"             {printf("%s\tRCB\n",yytext);}

"="             {printf("%s\tASSIGN\n",yytext);}
"+"             {printf("%s\tOPERATOR\n",yytext);}
"-"             {printf("%s\tOPERATOR\n",yytext);}
"*"             {printf("%s\tOPERATOR\n",yytext);}
"/"             {printf("%s\tOPERATOR\n",yytext);}

"^"             {printf("%s\tASSIGN\n",yytext);}
"%"             {printf("%s\tASSIGN\n",yytext);}

">"             {printf("%s\tRELATIONAL\n",yytext);}
"<"             {printf("%s\tRELATIONAL\n",yytext);}
">="            {printf("%s\tRELATIONAL\n",yytext);}
"<="            {printf("%s\tRELATIONAL\n",yytext);}
"=="            {printf("%s\tRELATIONAL\n",yytext);}

[\"]            {ECHO;BEGIN(QUOTATION);}
<QUOTATION>[\"] {ECHO;BEGIN(INITIAL); printf("\tQUOTATION STRING\n");}
<QUOTATION>.    {printf("%s",yytext);}

[\n]            {printf("\\n\tNEW LINE\n");}
{symbol}        {if(VAR==1) {
                        printf("%s\tint TYPE VAR\n", yytext);
                } else if(VAR==2) {
                        printf("%s\tdouble TYPE VAR\n", yytext);
                } else {
                        printf("%s\tID\n", yytext);
                }VAR=0;}
{number}        {printf("%s\tINT NUMBER\n",yytext);}
{double}        {printf("%s\tDOUBLE NUMBER\n",yytext);}


%%

int main(int argc,char *argv[]){ 
        int i = 1;
        while (argv[i]) {
                printf("\n#######################################\n");
                printf("opening file %s\n\n", argv[i]);
                yyin = fopen(argv[i++],"r");
                if (!yyin) break;
                yylex();
        }
        return 0;
}

int yywrap(void) {     
        return 1;
}

