%{
        #include <stdio.h>
        #include <stdlib.h>
        #include <ctype.h>
        #include <string.h>

        typedef struct node_t {
                int     index;
                char*   id;
                int     type;
                struct node_t* next;
        } node_t;

        typedef struct table_t {
                node_t* head;
                int     number;
        } table_t;

        table_t* symbol_table;

        void create_table() {
                symbol_table = (table_t*)malloc(sizeof(table_t));
                symbol_table -> number = 0;
                symbol_table -> head = (node_t*)malloc(sizeof(node_t));
                printf("Create a symbol table\n");
        } 
        node_t* look_into (node_t* ptr) {
                if (!ptr) return ptr;
                while(ptr -> next){
                        ptr = ptr -> next;
                }
                return ptr;
        }

        void insert (char* ID, int TYPE, table_t* self) {
                node_t* ptr = (node_t*)malloc(sizeof(node_t));
                node_t* tmp;
                ptr -> index = self -> number++ +1;
                ptr -> id = (char*)malloc(sizeof(char)*strlen(ID));
                strcpy(ptr -> id, ID);
                ptr -> type = TYPE;
                tmp = look_into(self -> head);
                tmp -> next = ptr;
                printf("Insert a symbol:%s\n", ptr -> id);
        }
        int lookup(char* ID, table_t* self) {

        }
        void dump(table_t* self) {
                printf("\nDumping symbol table...%d\n\n", self -> number);
                printf("Index\tID\tType\n");
                const char* type_t[2] = {"int", "double"};
                node_t* p = self -> head -> next;
                while(p){
                        printf("%d\t%s\t%s\n", p -> index, p -> id, type_t[p -> type]);
                        p = p -> next;
                }
        }
%}

letter    [a-zA-Z] 
digit     [0-9] 
symbol    {letter}+({letter}|{digit})* 
number    {digit}+
double    {digit}*\.{digit}+

%x C_COMMENT
%x CP_COMMENT
%x QUOTATION
%x TYPEI
%x TYPED

%%

"//"            {printf(" > C++ COMMENT//");
                 BEGIN(CP_COMMENT);}
<CP_COMMENT>\n  {printf("\n");BEGIN(INITIAL);}
<CP_COMMENT>.   {printf("%s", yytext);}

"/*"            {printf(" > C COMMENT START /*\n > ");
                 BEGIN(C_COMMENT);}
<C_COMMENT>"*/" {printf("*/ C COMMENT END\n");
                 BEGIN(INITIAL);}
<C_COMMENT>\n   {printf("\n > ");}
<C_COMMENT>.    {printf("%s", yytext);}

[\t ]           {}
(?i:int)        {BEGIN(TYPEI);}
<TYPEI>[\t ]    {}
<TYPEI>{symbol} {printf("%s\tint TYPE VAR\n", yytext);
                 if(!symbol_table){create_table();}
                 insert(yytext, 0, symbol_table);
                 BEGIN(INITIAL);}
(?i:double)     {BEGIN(TYPED);}
<TYPED>[\t ]    {}
<TYPED>{symbol} {printf("%s\tdouble TYPE VAR\n", yytext);
                 if(!symbol_table){create_table();}
                 insert(yytext, 1, symbol_table);
                 BEGIN(INITIAL);}
(?i:print)      {printf("%s\tPRINT FUNCTIONN\n",yytext);}
(?i:if)         {printf("%s\tIF FUNCTIONN\n",yytext);}
(?i:else)       {printf("%s\tELSE FUNCTIONN\n",yytext);}
(?i:while)      {printf("%s\tWHILE FUNCTIONN\n",yytext);}

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
{symbol}        {printf("%s\tID\n", yytext);}
{number}        {printf("%s\tINT NUMBER\n",yytext);}
{double}        {printf("%s\tDOUBLE NUMBER\n",yytext);}


%%

int main(int argc,char *argv[]) { 
        int i = 1;
        while (argv[i]) {
                printf("\n#######################################\n");
                printf("opening file %s\n\n", argv[i]);
                yyin = fopen(argv[i++],"r");
                if (!yyin) break;
                yylex();
                dump(symbol_table);
                symbol_table = NULL;
        }
        return 0;
}

int yywrap(void) {     
        return 1;
}