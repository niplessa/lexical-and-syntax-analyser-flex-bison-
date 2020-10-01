/*Syntax Analyser (Parser)
PASC600
Nikos Plessas 
AEM : 615*/



/* BLOCK A: Statements block*/
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdlib.h>
#include <math.h>
#include "hashtbl.c" //include the hash table
HASHTBL *symbol; //Symbol Table declaration (global)


//#define MAX_LINE_SIZE 256

char filename[64];
extern FILE *yyin;
int scope; //global variable for scope, initialized to 0
error_no = 0; //global variable for error count initialized to 0
#define MAX_ERRORS 5 //max number of errors

%}

%union {
  unsigned int integer;
  double real;
  char *string;
  char character;
  int boolean;
}

//keywords
%token <string> T_PROGRAM T_CONST T_TYPE T_ARRAY T_OF T_VAR T_FORWARD T_FUNCTION T_PROCEDURE T_INTEGER T_REAL T_BOOLEAN T_CHAR T_STRING T_BEGIN T_END T_IF T_THEN T_ELSE T_WHILE T_DO T_FOR T_DOWNTO T_TO T_READ T_WRITE T_LENGTH T_ID T_SCONST//T_OTHERWISE T_CASE T_EOF 

//integer consts
%token <integer> T_ICONST

//real consts
%token <real> T_RCONST

//logical
%token <boolean> T_BCONST

//chars
%token <character> T_CCONST


//operators
%token <string> 
T_RELOP
T_ADDOP
T_OROP
T_MULDIVANDOP
T_NOTOP
T_LPAREN
T_RPAREN
T_SEMI
T_DOT
T_COMMA
T_COLON
T_LBRACK
T_RBRACK
T_ASSIGN
T_DOTDOT
T_EQU

//assoc and priority (operators)
%nonassoc T_COLON
%nonassoc T_LBRACK T_RBRACK
%left T_OROP
%nonassoc T_RELOP
%nonassoc T_NOTOP
%left T_ADDOP
%left T_MULDIVANDOP
%right T_EQU
%nonassoc T_LPAREN T_RPAREN

//solving dangling else
%nonassoc T_THEN
%nonassoc T_ELSE

//start symbol of the Grammar = program
//%start program;


%%
/*BLOCK B: Rules block*/

program: header declarations subprograms comp_statement T_DOT
    ;

header: T_PROGRAM T_ID T_SEMI {hashtbl_insert(symbol,$1,NULL,scope);}
    ;

declarations: constdefs typedefs vardefs
    ;

constdefs: T_CONST constant_defs T_SEMI
    |/*empty*/
    ;
        
constant_defs: constant_defs T_SEMI T_ID T_EQU expression {hashtbl_insert(symbol,$3,NULL,scope);}
    | T_ID T_EQU expression {hashtbl_insert(symbol,$1,NULL,scope);}
    ;
            
expression: expression T_RELOP expression
    | expression T_EQU expression
    | expression T_OROP expression
    | expression T_ADDOP expression
    | expression T_MULDIVANDOP expression
    | T_ADDOP expression
    | T_NOTOP expression
    | variable
    | T_ID T_LPAREN expressions T_RPAREN
    | T_LENGTH T_LPAREN expression T_RPAREN
    | constant
    | T_LPAREN expression T_RPAREN
    ;
            
variable: T_ID {hashtbl_insert(symbol,$1,NULL,scope);}
    | variable T_LBRACK expressions T_RBRACK
    ;
         
expressions: expressions T_COMMA expression
    | expression
    ;
            
constant: T_ICONST
    | T_RCONST
    | T_BCONST
    | T_CCONST
    | T_SCONST
    ;
        
typedefs: T_TYPE type_defs T_SEMI
    |/*empty*/
    ;
        
type_defs: type_defs T_SEMI T_ID T_EQU type_def {hashtbl_insert(symbol,$3,NULL,scope);}
    | T_ID T_EQU type_def {hashtbl_insert(symbol,$1,NULL,scope);}
    ;
        
type_def: T_ARRAY T_LBRACK dims  T_RBRACK T_OF typename
    | T_LPAREN identifiers T_RPAREN
    | limit T_DOTDOT limit
    ;
        
dims: dims T_COMMA limits
    | limits
    ;
    
limits: limit T_DOTDOT limit
    | T_ID {hashtbl_insert(symbol,$1,NULL,scope);}
    ;
    
limit: sign T_ICONST
    | T_CCONST
    | T_BCONST
    | T_ADDOP T_ID {hashtbl_insert(symbol,$2,NULL,scope);}
    | T_ID
    ;
    
sign: T_ADDOP
    |/*empty*/
    ;
    
typename: standard_type
    | T_ID {hashtbl_insert(symbol,$1,NULL,scope);}
    ;
    
standard_type: T_INTEGER
    | T_REAL
    | T_BOOLEAN
    | T_CHAR
    | T_STRING
    ;
    
vardefs: T_VAR variable_defs T_SEMI
    |/*empty*/
    ;
    
variable_defs: variable_defs T_SEMI identifiers T_COLON typename
    | identifiers T_COLON typename;
    
identifiers: identifiers T_COMMA T_ID {hashtbl_insert(symbol,$3,NULL,scope);}
    | T_ID {hashtbl_insert(symbol,$1,NULL,scope);}
    ;
    
subprograms: subprograms subprogram T_SEMI
    |/*empty*/
    ;
    
subprogram: sub_header T_SEMI T_FORWARD
    | sub_header T_SEMI declarations subprograms comp_statement
    ;
    
sub_header: T_FUNCTION T_ID formal_parameters T_COLON typename
    | T_PROCEDURE T_ID formal_parameters
    | T_FUNCTION 
    ;
    
formal_parameters: T_LPAREN parameter_list T_RPAREN
    |/*empty*/
    ;
    
parameter_list: parameter_list T_SEMI pass identifiers T_COLON typename
    | pass identifiers T_COLON typename;
    
pass: T_VAR
    |/*empty*/
    ;
    
comp_statement: T_BEGIN statements T_END
    ; 

statements: statements T_SEMI statement
    | statement
    ;
    
statement: assignment
    | if_statement
    | while_statement
    | for_statement
    | subprogram_call
    | io_statement
    | comp_statement
    |//empty
    ;
    
    
assignment: variable T_ASSIGN expression
    ;

//shift-reduce error on IF: 
// combine if_statement & if_tail as one rule
// define prec&priority as: 
// %nonassoc T_THEN
// %nonassoc T_ELSE see O'Rilley page 208

if_statement: T_IF expression T_THEN statement 
    | T_IF expression T_THEN statement  T_ELSE statement
    | error {yyerrok;yyclearin;printf("Error at IF--ignoring. Total errors: %d\n",error_no);} //ignore error on "IF" so that parsing can complete
    ;
    
while_statement: T_WHILE  expression {scope++;} T_DO statement {hashtbl_get(symbol,scope);scope--;} 
    ;

for_statement: T_FOR T_ID T_ASSIGN iter_space {scope++;} T_DO statement {hashtbl_get(symbol,scope);scope--;}
    ;

iter_space: expression T_TO expression
    | expression T_DOWNTO expression
    ;
    
subprogram_call: T_ID
    | T_ID T_LPAREN expression T_RPAREN
    ;
    

io_statement: T_READ T_LPAREN read_list T_RPAREN
    | T_WRITE T_LPAREN write_list T_RPAREN
    ;
    
read_list: read_list T_COMMA read_item
    | read_item
    ;
    
    
read_item: variable
    ;

write_list: write_list T_COMMA write_item
    |write_item
    ;
    
write_item: expression
    ;

%%
/*BLOCK C: Functions*/
int  main(int argc,char ** argv){
    int out;
    
    //check if an input file is passed as an argument
	if(argc<2){
        printf("No input file!\n");
		exit(1);
    }
		
	yyin = fopen(argv[1],"r");
    strcpy(filename, argv[1]);

    if (yyin == NULL) {
        printf("File not found!\n");
        exit(1);
    }
    
    //input file ok!
    
    //symbol table initialize/create
    if(!(symbol=hashtbl_create(16, NULL))) {
    fprintf(stderr, "ERROR: hashtbl_create() failed\n");
    exit(EXIT_FAILURE);
    }

        
    out=yyparse();
    printf("Syntax analyzer started.\n");
    

    if(!out) {// yyparse == 0 - parsing completed
    printf("Syntax analyzer finished succesfully.\n");
    fclose(yyin);
    printf("File closed succesfully\n");
    return(0);
    }
    
    else { //yyparse()==1 - could not complete parsing
        printf("Syntax analyzer failed\n");
        hashtbl_destroy(symbol);
        fclose(yyin); // close input file
        printf("File closed succesfully\n");
        return(1);
    }

	
	
}



extern int line_no;

void yyerror(char *s) {
    error_no++;
    fprintf(stderr, "line %d: %s\n", line_no, s);
}

//cemetary -- things that i'm not 100% sure that must be erased

/*
statement: notif_statement
    | if_statement
    ;

    
notif_statement: assignment
    | while_statement
    | for_statement
    | subprogram_call
    | io_statement
    | comp_statement
    |//empty
    ;
    
if_statement: matched
    | unmatched
    ;
    
matched: T_IF expression T_THEN matched T_ELSE matched
    | notif_statement
    ;
    
unmatched: T_IF expression T_THEN if_statement
    | T_IF expression T_THEN matched T_ELSE unmatched
    ;



*/


