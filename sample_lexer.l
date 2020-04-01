%option noyywrap
%{
#include <iostream>
using namespace std;
int nums = 0;
%}

ALLOWED		[A-Za-z0-9]*[fF][A-Za-z0-9]*

%%
{ALLOWED}	{cout << "Found this f-word: " << yytext << endl; nums++;}
.|\n		{}
%%

int main() {
	FlexLexer *lexer = new yyFlexLexer;
	lexer->yylex();
	cout << "There are " << nums << " f-words." << endl;
	return 0;
}
