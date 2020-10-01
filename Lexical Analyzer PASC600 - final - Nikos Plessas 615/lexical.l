/*Lexical Analyser (Lexer)
PASC600
Nikos Plessas 
AEM : 615*/

/*part Α - statements block/*/

%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "hashtbl.c" //include the hash table
HASHTBL *symbol; //Symbol Table declaration (global)

FILE *fd; //a global copy of the input file -- accessible from error funtion

int line_no = 1;
int errors = 0;

char strbuffer[200];//a string buffer to properly return strings

char *ptr;

int doubletoint;

//declaring a dummy yylval in order to return through it constants and strings -- Delete it later in bison
union  {
  unsigned int integer;
  double real;
  char string[200];
  char character;
  int boolean;
} yylval;

/*antistoixhsh lektikwn monadwn (telikwn katastasewn) me ari8mous - kwdikoys eksodoy*/

#define T_EOF       0
#define T_PROGRAM   1
#define T_PROCEDURE 2
#define T_CHAR      3
#define T_CONST     4
#define T_CASE      5
#define T_TYPE      6
#define T_TO        7
#define T_THEN      8
#define T_BCONST    9
#define T_ARRAY     10
#define T_OF        11
#define T_OTHERWISE 12
#define T_VAR       13
#define T_FORWARD   14
#define T_FOR       15
#define T_FUNCTION  16
#define T_INTEGER   17
#define T_IF        18
#define T_REAL      19
#define T_READ      20
#define T_BEGIN     21
#define T_BOOLEAN   22
#define T_STRING    23
#define T_END       24
#define T_ELSE      25
#define T_EQU       26
#define T_WHILE     27
#define T_WRITE     28
#define T_DOWNTO    29
#define T_DO        30
#define T_LENGTH    31
#define T_ID        32
#define T_ICONST    33
#define T_RCONST    34
#define T_CCONST    35
#define T_SCONST    36
#define T_DOT       37
#define T_DOTDOT    38
#define T_RELOP     39
#define T_ADDOP     40
#define T_LPAREN    41
#define T_RPAREN    42
#define T_SEMI      43
#define T_COMMA     44
#define T_COLON     45
#define T_ASSIGN    46
#define T_LBRACK    47
#define T_RBRACK    48
#define T_MULDIVANDOP   49
#define T_NOTOP     50
#define T_OROP      51



void ERROR (const char msg [], char *text); //synarthsh epistrofis la8oys
double decRealHandler(char *str); //convert string to real
double hexRealHandler(char *str); //conver hex real string to real

%}

%option noyywrap
%option case-insensitive
%x STRINGS
%x COMMENTS

/*Kefalaioi kai pezoi xarakthres toy agglikoy alfavhtoy*/
L   [A-Za-z]
/*ola ta ari8mhtika pshfia*/
D   [0-9]
/*ari8mhtika ektos toy mhdenos*/
Dp  [1-9]
/*Grammata poy xrhsimopioyntai sta dekaeksadika*/
Hex [A-Fa-f]
/*kena, tab, newlines*/
W   [ \t] 
/*eidikoi xarakthres*/
SPEC [NnFfTtVvBbRr]
/*all ASCII*/
ASCII [ -~]



/*Part B: RULES BLOCK*/
%%
"PROGRAM"   {printf("Keyword: "); return(T_PROGRAM);}
"CONST"     {printf("Keyword: "); return(T_CONST);}
"TYPE"      {printf("Keyword: "); return(T_TYPE);}
"ARRAY"     {printf("Keyword: "); return(T_ARRAY);}
"OF"        {printf("Keyword: "); return(T_OF);}
"VAR"       {printf("Keyword: "); return(T_VAR);}
"FORWARD"   {printf("Keyword: "); return(T_FORWARD);}
"FUNCTION"  {printf("Keyword: "); return(T_FUNCTION);}
"PROCEDURE" {printf("Keyword: "); return(T_PROCEDURE);}
"INTEGER"   {printf("Keyword: "); return(T_INTEGER);}
"REAL"      {printf("Keyword: "); return(T_REAL);}
"BOOLEAN"   {printf("Keyword: "); return(T_BOOLEAN);}
"CHAR"      {printf("Keyword: "); return(T_CHAR);}
"STRING"    {printf("Keyword: "); return(T_STRING);}
"BEGIN"     {printf("Keyword: "); return(T_BEGIN);}
"END"       {printf("Keyword: "); return(T_END);}
"IF"        {printf("Keyword: "); return(T_IF);}
"THEN"      {printf("Keyword: "); return(T_THEN);}
"ELSE"      {printf("Keyword: "); return(T_ELSE);}
"CASE"      {printf("Keyword: "); return(T_CASE);}
"OTHERWISE" {printf("Keyword: "); return(T_OTHERWISE);}
"WHILE"     {printf("Keyword: "); return(T_WHILE);}
"DO"        {printf("Keyword: "); return(T_DO);}
"FOR"       {printf("Keyword: "); return(T_FOR);}
"DOWNTO"    {printf("Keyword: "); return(T_DOWNTO);}
"TO"        {printf("Keyword: "); return(T_TO);}
"READ"      {printf("Keyword: "); return(T_READ);}
"WRITE"     {printf("Keyword: "); return(T_WRITE);}
"LENGTH"    {printf("Keyword: "); return(T_LENGTH);}

"TRUE"|"FALSE"          {printf("Logical: "); return(T_BCONST);}


">"|">="|"<"|"<="|"<>" {printf("Relation Operator: "); return(T_RELOP);}
"+"|"-"                {printf("Additive Operator: "); return(T_ADDOP);}
"OR"                   {printf("OR Operator: "); return(T_OROP);}
"NOT"                  {printf("NOT Operator: "); return(T_NOTOP);}
"*"|"/"|"DIV"|"MOD"|"AND"   {printf("Multiplicant Operator: "); return(T_MULDIVANDOP);}

"("     {printf("LPAREN: "); return(T_LPAREN);}
")"     {printf("LRPAREN: "); return(T_RPAREN);}
";"     {printf("SEMI: "); return(T_SEMI);}
"."     {printf("DOT: "); return(T_DOT);}
","     {printf("COMMA: "); return(T_COMMA);}
"="     {printf("EQU: "); return(T_EQU);}
":"     {printf("COLON: "); return(T_COLON);}
"["     {printf("LBRACK: "); return(T_LBRACK);}
"]"     {printf("RBRACK: "); return(T_RBRACK);}
":="    {printf("ASSIGN: "); return(T_ASSIGN);}
".."    {printf("DOT_DOT: "); return(T_DOTDOT);}

\n      {line_no++;} //increase line counter when '\n' is encountered


(_)?{L}({L}|{D}|_)*({L}|{D})|{L}* {printf("ID: " );hashtbl_insert(symbol,yytext,NULL,0); strcpy(yylval.string,yytext); printf("yylval: %s ",yylval.string);
return(T_ID);} // REGEX: _?|L(L|D|L)*(L|D) -> ID


{Dp}({D})*|0 {printf("ICONST: "); yylval.integer = atoi(yytext); printf("yylval: %d ",yylval.integer); return(T_ICONST);}

{Dp}({D})*[Ee][+-]?(({D})*{Dp}) {printf("ICONST_2 exp: "); doubletoint = atof(yytext);  yylval.integer = doubletoint; printf("yylval: %d ",yylval.integer); return(T_ICONST);}


[0][Xx]({Dp}|{Hex})({Hex}|{D})* {printf("ICONST: (hex) "); yylval.integer = strtol(yytext,&ptr,16); printf("yylval: %d\n",yylval.integer); return(T_ICONST);}



({Dp}({D})*)?"."([0]|({D})*{Dp})([Ee]([+-]?{D}*){Dp})? {printf("RCONST_1:"); yylval.real = decRealHandler(yytext); printf("yylval: %f ",yylval.real); return(T_RCONST);} 

[0][Xx](({Dp}|{Hex})({D}|{Hex})*)?[.]({D}|{Hex})* {printf("RCONST_2: (hex)"); yylval.real = hexRealHandler(yytext); printf("yylval: %f\n",yylval.real); return(T_RCONST);}

[']{ASCII}[']|['][\\]{SPEC}['] {printf("CCONST: "); yylval.character=yytext[1]; printf("yylval: %c ",yylval.character); return(T_CCONST);} //Character constant

["]                       {BEGIN(STRINGS);strbuffer[0] = '\0'; printf("String: ");}
<STRINGS>["]              {BEGIN(INITIAL);strcpy(yylval.string, strbuffer); printf("yylval: %s\n",yylval.string); return(T_STRING);}
<STRINGS>\\$              {printf("\n");}
<STRINGS>[\\]({SPEC})     {strcat(strbuffer, yytext);}
<STRINGS>[\\]["]          {strcat(strbuffer, yytext);}
<STRINGS>[\\]{ASCII}      {strcat(strbuffer, yytext);}
<STRINGS><<EOF>>          {ERROR("Strings must close with \" !",yytext);}
<STRINGS>\n               {line_no++;} //increase the line counter when newline occurs in a string
<STRINGS>{ASCII}          {strcat(strbuffer, yytext);}

[{]                       {BEGIN(COMMENTS); printf("This is a comment: ");}
<COMMENTS>[}]             {BEGIN(INITIAL); printf("\n");}
<COMMENTS>\n              {line_no++;} //increase the line counter when newline occurs in a comment
<COMMENTS>.               {printf("%s",yytext);}

"<<EOF>>" {return(T_EOF); exit(1);}


{W} {/*return nothing for whitespaces*/}

.   {yyless(1); errors++; ERROR("illegal token",yytext); }
    
    
%%
/*part C: Functions*/

int main (int argc, char *argv[]) {

    //symbol table initialize
	if(!(symbol=hashtbl_create(16, NULL))) {
		fprintf(stderr, "ERROR: hashtbl_create() failed\n");
		exit(EXIT_FAILURE);
	}    

    int token;
    char c;
    

    
    //read from the terminal //just for testing reasons
    if (argc<2) {
        do {
                token = yylex();
                printf("token exit code = %d, lexeme = \"%s\"\n", token, yytext);
            }   while (token != T_EOF);
            
        line_no--; //don't count the last (blank) line
        printf("\n\nTotal lines: %d\n",line_no); 
        
        //hashtbl_get(symbol,0); //get all ids from symbol table with scope = 0
        return(0);
        }
        
    //read from test file
    else {
        fd = fopen(argv[1],"r"); //read argv[1] to global file fd -- accessible from error()
        yyin = fopen(argv[1], "r");
        do {
            token = yylex();
            printf("token exit code = %d, lexeme = \"%s\", line = %d \n", token, yytext,line_no);
            }   while (token != T_EOF);
            
        line_no--; //don't count the last (blank) line
        printf("\n\nTotal lines: %d\n",line_no); 
        //hashtbl_get(symbol,0); //get all ids from symbol table with scope = 0
        fclose(yyin);
        

        }
}

void ERROR (const char msg [], char *text) {
    /* code to print the erroneous line
    reopen input file and print the line that corresponds to line_no -> number of the line that the error occured*/
    int end, loop, line; 
    char str[512];

    if (fd == NULL) {printf("Failed to open file\n");}

    for(end = loop = 0;loop<line_no;++loop){
        if(0==fgets(str, sizeof(str), fd)){//include '\n'
            end = 1;//can't input (EOF)
            break;
        }
    }
    fprintf(stderr, "\nERROR at line %d. Error type: %s. Error line: %sTotal errors: %d \n",line_no, msg,str,errors);
    fclose(fd);
    if (errors>1) {
    printf("More than one errors!--early termination\n");
    exit(1);}
    }

//synarthseis xeirismoy ari8mwn
double decRealHandler(char *str) {
	char *b = str;
	int decimal = 0;
	
	while(*b!='.') {
		decimal = decimal*10 + (*b-'0');
		*b++;
	}
	
	*b++;
	int power=0;
	while(*b!='\0' && *b!='E' && *b!='e') {
		decimal = decimal*10 + (*b-'0');
		power--;
		*b++;
	}
	
	if(*b=='E' || *b=='e') {
		*b++;
		
		int power2=0;
		if(*b=='-') {
			*b++;
			while(*b!='\0') {
				power2 = power2*10 + (*b-'0');
				*b++;
			}
			
			power -= power2;
		}
		else {
			if(*b=='+') *b++;
			
			while(*b!='\0') {
				power2 = power2*10 + (*b-'0');
				*b++;
			}
			
			power += power2;
		}
	}
	
	return decimal*pow(10, power);
}

double hexRealHandler(char *str) {
	char *b = str+2;
	int decimal = 0;
	
	while(*b!='.') {
		decimal *= 16;
		
		if(*b >= 'A' && *b <= 'F') {
			decimal += *b-'A'+10;
		}
		else if(*b >= 'a' && *b <= 'f') {
			decimal += *b-'a'+10;
		}
		else {
			decimal += *b-'0';
		}
		
		*b++;
	}
	
	*b++;
	int power=0;
	while(*b!='\0') {
		decimal *= 16;
		
		if(*b >= 'A' && *b <= 'F') {
			decimal += *b-'A'+10;
		}
		else if(*b >= 'a' && *b <= 'f') {
			decimal += *b-'a'+10;
		}
		else {
			decimal += *b-'0';
		}
		power--;
		*b++;
	}
	
	return decimal*pow(16, power);
	}
