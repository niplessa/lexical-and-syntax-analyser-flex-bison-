/*Lexical Analyser (Lexer) for Syntax Analyser
PASC600
Nikos Plessas 
AEM : 615*/

/*part Α - statements block/*/

%{
#include "syntax.tab.h" //include bison's header file
//#include "syntax.tab.c" //include bison's .c file...not sure
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

//used in error function
FILE *fd; //a global copy of the input file -- accessible from error funtion
int line_no = 1;
int errors = 0;

char strbuffer[200];//a string buffer to properly return strings
char *ptr; //used in strtol function
int doubletoint; //convert double to int


//#include "hashtbl.h" //include the hash table
//extern HASHTBL *symbol; //Symbol Table declaration (global)

/*antistoixhsh lektikwn monadwn (telikwn katastasewn) me ari8mous - kwdikoys eksodoy*/


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
"PROGRAM"   {yylval.string = strdup(yytext); return(T_PROGRAM); } //passing yytext as string to yylvalue...
"CONST"     {yylval.string = strdup(yytext); return(T_CONST);}
"TYPE"      {yylval.string = strdup(yytext); return(T_TYPE);}
"ARRAY"     {yylval.string = strdup(yytext); return(T_ARRAY);}
"OF"        {yylval.string = strdup(yytext); return(T_OF);}
"VAR"       {yylval.string = strdup(yytext); return(T_VAR);}
"FORWARD"   {yylval.string = strdup(yytext); return(T_FORWARD);}
"FUNCTION"  {yylval.string = strdup(yytext); return(T_FUNCTION);}
"PROCEDURE" {yylval.string = strdup(yytext); return(T_PROCEDURE);}
"INTEGER"   {yylval.string = strdup(yytext); return(T_INTEGER);}
"REAL"      {yylval.string = strdup(yytext); return(T_REAL);}
"BOOLEAN"   {yylval.string = strdup(yytext); return(T_BOOLEAN);}
"CHAR"      {yylval.string = strdup(yytext); return(T_CHAR);}
"STRING"    {yylval.string = strdup(yytext); return(T_STRING);}
"BEGIN"     {yylval.string = strdup(yytext); return(T_BEGIN);}
"END"       {yylval.string = strdup(yytext); return(T_END);}
"IF"        {yylval.string = strdup(yytext); return(T_IF);}
"THEN"      {yylval.string = strdup(yytext); return(T_THEN);}
"ELSE"      {yylval.string = strdup(yytext); return(T_ELSE);}
"WHILE"     {yylval.string = strdup(yytext); return(T_WHILE);}
"DO"        {yylval.string = strdup(yytext); return(T_DO);}
"FOR"       {yylval.string = strdup(yytext); return(T_FOR);}
"DOWNTO"    {yylval.string = strdup(yytext); return(T_DOWNTO);}
"TO"        {yylval.string = strdup(yytext); return(T_TO);}
"READ"      {yylval.string = strdup(yytext); return(T_READ);}
"WRITE"     {yylval.string = strdup(yytext); return(T_WRITE);}
"LENGTH"    {yylval.string = strdup(yytext); return(T_LENGTH);}

"TRUE"      {yylval.boolean = 1; return(T_BCONST);}
"FALSE"     {yylval.boolean = 0; return(T_BCONST);}


">"|">="|"<"|"<="|"<>" {yylval.string = strdup(yytext); return(T_RELOP);}
"+"|"-"                {yylval.string = strdup(yytext); return(T_ADDOP);}
"OR"                   {yylval.string = strdup(yytext); return(T_OROP);}
"NOT"                  {yylval.string = strdup(yytext); return(T_NOTOP);}
"*"|"/"|"DIV"|"MOD"|"AND"   {yylval.string = strdup(yytext); return(T_MULDIVANDOP);}

"("     {yylval.string = strdup(yytext); return(T_LPAREN);}
")"     {yylval.string = strdup(yytext); return(T_RPAREN);}
";"     {yylval.string = strdup(yytext); return(T_SEMI);}
"."     {yylval.string = strdup(yytext); return(T_DOT);}
","     {yylval.string = strdup(yytext); return(T_COMMA);}
"="     {yylval.string = strdup(yytext); return(T_EQU);}
":"     {yylval.string = strdup(yytext); return(T_COLON);}
"["     {yylval.string = strdup(yytext); return(T_LBRACK);}
"]"     {yylval.string = strdup(yytext); return(T_RBRACK);}
":="    {yylval.string = strdup(yytext); return(T_ASSIGN);}
".."    {yylval.string = strdup(yytext); return(T_DOTDOT);}

\n      {line_no++;} //increase line counter when '\n' is encountered


(_)?{L}({L}|{D}|_)*({L}|{D})|{L}* {yylval.string = strdup(yytext); return(T_ID);} //ID _hashtbl_insert(symbol,yytext,NULL,0);


{Dp}({D})*|0 {yylval.integer = atoi(yytext);return(T_ICONST);}//INTEGER CONST

{Dp}({D})*[Ee][+-]?(({D})*{Dp}) {doubletoint = atof(yytext);yylval.integer = doubletoint;return(T_ICONST);}

[0][Xx]({Dp}|{Hex})({Hex}|{D})* {yylval.integer = strtol(yytext,&ptr,16);return(T_ICONST);}//HEX INTEGER CONST



({Dp}({D})*)?"."([0]|({D})*{Dp})([Ee]([+-]?{D}*){Dp})? {yylval.real = decRealHandler(yytext);return(T_RCONST);}//REAL CONST EXP OR NOT

[0][Xx](({Dp}|{Hex})({D}|{Hex})*)?[.]({D}|{Hex})* {yylval.real = hexRealHandler(yytext);return(T_RCONST);}//HEX REAL CONST

[']{ASCII}[']|['][\\]{SPEC}['] {yylval.character=yytext[1];return(T_CCONST);} //CHAR CONST

["]                       {BEGIN(STRINGS);strbuffer[0] = '\0';}
<STRINGS>["]              {BEGIN(INITIAL);strcpy(yylval.string, strbuffer);return(T_STRING);}
<STRINGS>\\$              {}
<STRINGS>[\\]({SPEC})     {strcat(strbuffer, yytext);}
<STRINGS>[\\]["]          {strcat(strbuffer, yytext);}
<STRINGS>[\\]{ASCII}      {strcat(strbuffer, yytext);}
<STRINGS><<EOF>>          {ERROR("Strings must close with \" !",yytext);}
<STRINGS>\n               {line_no++;} //increase the line counter when newline occurs in a string
<STRINGS>{ASCII}          {strcat(strbuffer, yytext);}

[{]                       {BEGIN(COMMENTS);}
<COMMENTS>[}]             {BEGIN(INITIAL);}
<COMMENTS>\n              {line_no++;} //increase the line counter when newline occurs in a comment
<COMMENTS>.               {}

<<EOF>> {return(0);}


{W} {/*return nothing for whitespaces*/}

.   {yyless(1); errors++; ERROR("illegal token",yytext); }
    
    
%%
void ERROR (const char msg [], char *text) {
    /* code to print the erroneous line
    reopen input file and print the line that corresponds to line_no -> number of the line that the error occured*/
    int end, loop; 
    char str[512];

    if (fd == NULL) {printf("Failed to open file\n");}

    for(end = loop = 0;loop<line_no;++loop){
        if(0==fgets(str, sizeof(str), fd)){//include '\n'
            end = 1;//can't input (EOF)
            break;
        }
    }
    fprintf(stderr, "\n LEXIXAL ERROR at line %d. Error type: %s. Error line: %sTotal errors: %d \n",line_no, msg,str,errors);
    fclose(fd);
    if (errors>1) {
    printf("More than one **Lexical** errors!--early termination\n");
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


//cemetary -- things that i'm not 100% sure that must be erased
/*

//CASE & OTHERWISE NOT PRESENT IN GRAMMAR (must delete?)
"CASE"      {yylval.string = strdup(yytext); return(T_CASE);}
"OTHERWISE" {yylval.string = strdup(yytext); return(T_OTHERWISE);}

*/
