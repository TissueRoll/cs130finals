%option noyywrap
%{
#include <iostream>
#include <stack>
using namespace std;
stack<string> present_tags;
bool close_tag_opened = false;
bool in_comment = false;
%}

SCOMMENT	"<!--"
ECOMMENT	"-->"
PLUS		"+"
MINUS		"-"
MULT		"*"
DIVIDE		"/"
MODULO		"%"
EXP			{MULT}{MULT}
LPAREN		"("
RPAREN		")"
EQUALS		"="
LTHAN		"<"
GTHAN		">"
COLON		":"
SCOLON		";"
COMMA		","
PERIOD		"."
QUOTE		[']
DQUOTE		["]
INTEGER		[0-9]+
VNUMBER		({MINUS}?{INTEGER})|({MINUS}?{INTEGER}{PERIOD}{INTEGER})|({MINUS}?{INTEGER}[eE]{MINUS}?{INTEGER})|({MINUS}?{INTEGER}{PERIOD}{INTEGER}[eE]{MINUS}?{INTEGER})
IDENT		[a-zA-Z]+
TAGIDENT	{LTHAN}{IDENT}
ENDTAGHEAD	{LTHAN}{DIVIDE}
VSYMBS		{PLUS}|{MINUS}|{MULT}|{DIVIDE}|{MODULO}|{EXP}|{LPAREN}|{RPAREN}|{EQUALS}|{LTHAN}|{GTHAN}|{COLON}|{SCOLON}|{COMMA}|{PERIOD}|{QUOTE}|{DQUOTE}
IVSYMBS		[!@#$^&?]
ASYMBS		{VSYMBS}|{IVSYMBS}
INUMBER		({MINUS}?{INTEGER}{PERIOD}({ASYMBS}|{IDENT})+)|({MINUS}?{INTEGER}[eE]{MINUS}?({ASYMBS}|{IDENT})+)|({MINUS}?{INTEGER}{PERIOD}{INTEGER}[eE]{MINUS}?({ASYMBS}|{IDENT})+)

%%
{SCOMMENT}			{in_comment = true;}
{ECOMMENT}			{in_comment = false;}
{IVSYMBS}			{if (not in_comment) {cout << "***lexical error: illegal character (" << yytext << ")" << endl;}}
{INUMBER}			{if (not in_comment) {cout << "***lexical error: badly formed number" << endl << "NUMBER\t\t" << yytext << endl;}}
{PLUS}				{if (not in_comment) {cout << "PLUS\t\t" << yytext << endl;}}
{MINUS}				{if (not in_comment) {cout << "MINUS\t\t" << yytext << endl;}}
{MULT}				{if (not in_comment) {cout << "MULT\t\t" << yytext << endl;}}
{DIVIDE}			{if (not in_comment) {cout << "DIVIDE\t\t" << yytext << endl;}}
{MODULO}			{if (not in_comment) {cout << "MODULO\t\t" << yytext << endl;}}
{EXP}				{if (not in_comment) {cout << "EXP\t\t" << yytext << endl;}}
{LPAREN}			{if (not in_comment) {cout << "LPAREN\t\t" << yytext << endl;}}
{RPAREN}			{if (not in_comment) {cout << "RPAREN\t\t" << yytext << endl;}}
{EQUALS}			{if (not in_comment) {cout << "EQUALS\t\t" << yytext << endl;}}
{LTHAN}				{if (not in_comment) {cout << "LTHAN\t\t" << yytext << endl;}}
{GTHAN}				{if (not in_comment) {cout << "GTHAN\t\t" << yytext << endl;}}
{COLON}				{if (not in_comment) {cout << "COLON\t\t" << yytext << endl;}}
{SCOLON}			{if (not in_comment) {cout << "SCOLON\t\t" << yytext << endl;}}
{COMMA}				{if (not in_comment) {cout << "COMMA\t\t" << yytext << endl;}}
{PERIOD}			{if (not in_comment) {cout << "PERIOD\t\t" << yytext << endl;}}
{QUOTE}				{if (not in_comment) {cout << "QUOTE\t\t" << yytext << endl;}}
{DQUOTE}			{if (not in_comment) {cout << "DQUOTE\t\t" << yytext << endl;}}
{VNUMBER}			{if (not in_comment) {cout << "NUMBER\t\t" << yytext << endl;}}
{IDENT}				{if (not in_comment) {cout << "IDENT\t\t" << yytext << endl;}}
{TAGIDENT}			{if (not in_comment) {cout << "TAGIDENT\t" << yytext << endl;}}
{ENDTAGHEAD}		{if (not in_comment) {cout << "ENDTAGHEAD\t" << yytext << endl;}}
.|\n				{}
%%

int main() {
	FlexLexer *lexer = new yyFlexLexer;
	lexer->yylex();
	if (present_tags.size() > 0) {
		cout << "gg" << endl;
	}
	cout << "End of Lexer" << endl;
	return 0;
}
