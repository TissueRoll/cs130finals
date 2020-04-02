%option noyywrap
%{
#include <iostream>
#include <string>
#include <stack>
using namespace std;
stack<string> present_tags;
bool in_comment = false;
bool matched_tag = false;
int prev_prev_symbol = -1;
int prev_symbol = -1;

enum {
	SCOMMENT, ECOMMENT, PLUS, MINUS, MULT, DIVIDE, MODULO, EXP, 
	LPAREN, RPAREN, EQUALS, LTHAN, GTHAN, COLON, SCOLON, COMMA, PERIOD, QUOTE, DQUOTE, 
	VNUMBER, IDENT, TAGIDENT, ENDTAGHEAD, IVSYMBS, INUMBER
};

void safe_pop() {
	if (present_tags.size() > 0)
		present_tags.pop();
}

void check_validity(int ops, string text) {
	string temp = present_tags.size() > 0 ? present_tags.top() : "";
	int tsz = temp.size();

	if (in_comment == true and ops != ECOMMENT) {
		return;
	} else if (in_comment == true and ops == ECOMMENT) {
		safe_pop();
		return;
	}

	if (ops == TAGIDENT or ops == SCOMMENT) {
		present_tags.push(text);
	}

	if (prev_symbol == ENDTAGHEAD and ops == IDENT) {
		if (present_tags.size() == 0) {
			cout << "***lexical error: missing start tag, found end tag" << endl;
		} else {
			if (temp.substr(1,tsz-1) == text) {
				matched_tag = true;
			} else {
				cout << "mismatching end tag: expected " << temp.substr(1,tsz-1) << ", found " << text << endl;
			}
		}
	} else if (prev_symbol == ENDTAGHEAD and ops != IDENT) {
		cout << "***lexical error: invalid end tag: found " << text << endl;
	} else if (prev_prev_symbol == ENDTAGHEAD and prev_symbol == IDENT and ops == GTHAN) {
		if (matched_tag) {
			matched_tag = false;
			safe_pop();
		} else {
			cout << "***lexical error: unexpected error" << endl;
		}
	} else if (prev_prev_symbol == ENDTAGHEAD and prev_symbol == IDENT and ops != GTHAN) {
		// cout << "***lexcial error: invalid closing bracket: found " << text << endl;
	} else if (ops == ECOMMENT and not in_comment) {
		cout << "MINUS\t\t-\nMINUS\t\t-\nGTHAN\t\t>\n"; // BANDAID
	}
}

void do_operation(int ops, string text) {
	check_validity(ops, text);
	switch(ops) {
		case SCOMMENT:
			if (not in_comment)
				in_comment = true;
			break;
		case ECOMMENT:
			if (in_comment)
				in_comment = false;
			break;
		case PLUS:
			if (not in_comment) {
				cout << "PLUS\t\t" << text << endl;
			}
			break;
		case MINUS:
			if (not in_comment) {
				cout << "MINUS\t\t" << text << endl;
			}
			break;
		case MULT:
			if (not in_comment) {
				cout << "MULT\t\t" << text << endl;
			}
			break;
		case DIVIDE:
			if (not in_comment) {
				cout << "DIVIDE\t\t" << text << endl;
			}
			break;
		case MODULO:
			if (not in_comment) {
				cout << "MODULO\t\t" << text << endl;
			}
			break;
		case EXP:
			if (not in_comment) {
				cout << "EXP\t\t\t" << text << endl;
			}
			break;
		case LPAREN:
			if (not in_comment) {
				cout << "LPAREN\t\t" << text << endl;
			}
			break;
		case RPAREN:
			if (not in_comment) {
				cout << "RPAREN\t\t" << text << endl;
			}
			break;
		case EQUALS:
			if (not in_comment) {
				cout << "EQUALS\t\t" << text << endl;
			}
			break;
		case LTHAN:
			if (not in_comment) {
				cout << "LTHAN\t\t" << text << endl;
			}
			break;
		case GTHAN:
			if (not in_comment) {
				cout << "GTHAN\t\t" << text << endl;
			}
			break;
		case COLON:
			if (not in_comment) {
				cout << "COLON\t\t" << text << endl;
			}
			break;
		case SCOLON:
			if (not in_comment) {
				cout << "SCOLON\t\t" << text << endl;
			}
			break;
		case COMMA:
			if (not in_comment) {
				cout << "COMMA\t\t" << text << endl;
			}
			break;
		case PERIOD:
			if (not in_comment) {
				cout << "PERIOD\t\t" << text << endl;
			}
			break;
		case QUOTE:
			if (not in_comment) {
				cout << "QUOTE\t\t" << text << endl;
			}
			break;
		case DQUOTE:
			if (not in_comment) {
				cout << "DQUOTE\t\t" << text << endl;
			}
			break;
		case VNUMBER:
			if (not in_comment) {
				cout << "NUMBER\t\t" << text << endl;
			}
			break;
		case IDENT:
			if (not in_comment) {
				cout << "IDENT\t\t" << text << endl;
			}
			break;
		case TAGIDENT:
			if (not in_comment) {
				cout << "TAGIDENT\t" << text << endl;
			}
			break;
		case ENDTAGHEAD:
			if (not in_comment) {
				cout << "ENDTAGHEAD\t" << text << endl;
			}
			break;
		case IVSYMBS:
			if (not in_comment) {
				cout << "***lexical error: illegal character (" << text << ")" << endl;
			}
			break;
		case INUMBER:
			if (not in_comment) {
				cout << "***lexical error: badly formed number" << endl << "NUMBER\t\t" << text << endl;
			}
			break;
		default:
			cout << "unknown" << endl;
			break;
	}
	prev_prev_symbol = prev_symbol;
	prev_symbol = ops;
}

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
{SCOMMENT}			{do_operation(SCOMMENT, yytext);}
{ECOMMENT}			{do_operation(ECOMMENT, yytext);}
{IVSYMBS}			{do_operation(IVSYMBS, yytext);}
{INUMBER}			{do_operation(INUMBER, yytext);}
{PLUS}				{do_operation(PLUS, yytext);}
{MINUS}				{do_operation(MINUS, yytext);}
{MULT}				{do_operation(MULT, yytext);}
{DIVIDE}			{do_operation(DIVIDE, yytext);}
{MODULO}			{do_operation(MODULO, yytext);}
{EXP}				{do_operation(EXP, yytext);}
{LPAREN}			{do_operation(LPAREN, yytext);}
{RPAREN}			{do_operation(RPAREN, yytext);}
{EQUALS}			{do_operation(EQUALS, yytext);}
{LTHAN}				{do_operation(LTHAN, yytext);}
{GTHAN}				{do_operation(GTHAN, yytext);}
{COLON}				{do_operation(COLON, yytext);}
{SCOLON}			{do_operation(SCOLON, yytext);}
{COMMA}				{do_operation(COMMA, yytext);}
{PERIOD}			{do_operation(PERIOD, yytext);}
{QUOTE}				{do_operation(QUOTE, yytext);}
{DQUOTE}			{do_operation(DQUOTE, yytext);}
{VNUMBER}			{do_operation(VNUMBER, yytext);}
{IDENT}				{do_operation(IDENT, yytext);}
{TAGIDENT}			{do_operation(TAGIDENT, yytext);}
{ENDTAGHEAD}		{do_operation(ENDTAGHEAD, yytext);}
.|\n				{}
%%

int main() {
	FlexLexer *lexer = new yyFlexLexer;
	lexer->yylex();
	if (present_tags.size() > 0) {
		cout << "***lexical error: unexpected end of file" << endl;
	}
	return 0;
}
