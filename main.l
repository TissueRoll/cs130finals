%option noyywrap
%{
#include <iostream>
#include <stack>
using namespace std;
stack <string> s;
string temp;
bool checkEndTag;
%}

LETTER        	[a-zA-Z]+
OPERAND			[0-9]+
WHITE_SPACE    	[\n| |	]+

SCIENOTATION	[eE][\-+]?

PLUS			[+]
MINUS			[-]
MULT			[*]
DIVIDE			[/]
MODULO			[%]
EXP				"**"
LPAREN			[(]
RPAREN			[)]
EQUALS			[=]
LTHAN			[<]
GTHAN			[>]
COLON			[:]
SCOLON			[;]
COMMA			[,]
PERIOD			[.]
QUOTE			[']
DQUOTE			["]
NUMBER			[\-]?{OPERAND}{PERIOD}?{OPERAND}*({SCIENOTATION}{OPERAND})*

IDENT			{LETTER}
TAGIDENT 		[<]{LETTER}
ENDTAGHEAD		"</"

EXCLAMATION		[!]
AMPERSAND		[&]
CASH			[$]

BNUM1			[\-]?{OPERAND}{PERIOD}?[\-+]
BNUM2			[\-]?{OPERAND}{PERIOD}?{OPERAND}[eE]{LETTER}
BNUM3			[\-]?{OPERAND}{PERIOD}?{OPERAND}[eE][\-+]{LETTER}
BNUM4			[\-]?{OPERAND}{PERIOD}?{OPERAND}[eE][\-+]

COMMENT 		"<!--"([^-]|-[^-]|--+[^->])*-*"-->"
UNTERMINATED	"<!--"	

%%
{PLUS}							{cout << "PLUS       " << yytext << endl;}
{MINUS}							{cout << "MINUS      " << yytext << endl;}
{MULT}							{cout << "MULT       " << yytext << endl;}
{DIVIDE}						{cout << "DIVIDE     " << yytext << endl;}
{MODULO} 						{cout << "MODULO     " << yytext << endl;}
{EXP}							{cout << "EXP        " << yytext << endl;}

{LPAREN}						{cout << "LPAREN     " << yytext << endl;}
{RPAREN}						{cout << "RPAREN     " << yytext << endl;}
{EQUALS}						{cout << "EQUALS     " << yytext << endl;}
{LTHAN}							{cout << "LTHAN      " << yytext << endl;}
{GTHAN}							{cout << "GTHAN      " << yytext << endl;}
{COLON}							{cout << "COLON      " << yytext << endl;}
{SCOLON}						{cout << "SCOLON     " << yytext << endl;}
{COMMA}							{cout << "COMMA      " << yytext << endl;}
{PERIOD}						{cout << "PERIOD     " << yytext << endl;}
{QUOTE}							{cout << "QUOTE      " << yytext << endl;}
{DQUOTE}						{cout << "DQUOTE     " << yytext << endl;}
{NUMBER}						{cout << "NUMBER     " << yytext << endl;}



{IDENT}							{
									temp = yytext;
									if(checkEndTag){
										if (s.empty()){
											cout << "***lexical error: missing start tag, found end tag" << endl;
										}
										else if(temp == s.top()){
											s.pop();
										}
										else{
											cout << "***lexical error: mismatching end tag: expected " << s.top() 
											<< ", found " << temp << endl; 
										}
									}
									checkEndTag = false;
									cout << "IDENT      " << yytext << endl;
								}
							

{TAGIDENT}						{
									cout << "TAGIDENT   " << yytext << endl;
									temp = yytext;
									temp = temp.substr(1, temp.size());
									if(s.empty()){
										s.push(temp);									
									}
									else{
										if(s.top() == "tr" && temp == "tr"){

										}
										else if(s.top() == "td"){
											if(temp == "th"){
												s.pop();
												s.push(temp);
											}
										}
										else if(s.top() == "th"){
											if(temp == "td"){
												s.pop();
												s.push(temp);
											}
										}
										else{
											s.push(temp);
										}
									}
								}

{ENDTAGHEAD}					{cout << "ENDTAGHEAD " << yytext << endl; checkEndTag = true;}	

{WHITE_SPACE}|{COMMENT}   		{}

{BNUM1}|{BNUM2}|{BNUM3}|{BNUM4}	{cout << "***lexical error: badly formed number" << "\nNUMBER     " << yytext << endl;}

{EXCLAMATION}					{cout << "***lexical error: illegal character (!)" << endl;}
{AMPERSAND}						{cout << "***lexical error: illegal character (&)" << endl;}
{CASH}							{cout << "***lexical error: illegal character ($)" << endl;}

{UNTERMINATED}					{cout << "***lexical error: unexpected end of file" << endl; yyterminate();}

<<EOF>>        					{	
									if(!s.empty()) {
										cout << "***lexical error: unexpected end of file" << endl;
									}
									while(!s.empty()){
										s.pop();
									}
									yyterminate();
								}
%%

int main() {
    FlexLexer *lexer = new yyFlexLexer;
    lexer->yylex();
    return 0;
}