/*
 * A simple recursive descent parser for the CFG
 * S -> E
 * E -> E+T | T
 * T -> T*F | F
 * F -> (E) | a
 *
 * LL(1) version:
 * S -> E
 * E -> TE'
 * E' -> +TE' | eps
 * T -> FT'
 * T' -> *FT' | eps
 * F -> (E) | a
 */

#include <iostream>
#include <string>

using namespace std;

// special token to denote end of string
const char ENDSTR = '$';

string input;
char curr_token;
bool error;
int pos = 0;

void get_next_token() {
    if (pos == input.size())
        curr_token = ENDSTR;
    else
        curr_token = input[pos++];
}

void parse_error(string src) {
    cout << "parse error: " << src << " pos " << pos << endl;
    error = true;
}

void match(char token) {
    if (token == curr_token)
        get_next_token();
    else
        parse_error("expected " + token);
}

// forward declaration for each variable
void S();
void E();
void E_();
void T();
void T_();
void F();

// production S -> E
void S() {
    E();
    if (curr_token == ENDSTR && !error)
        cout << "string accepted!" << endl;
    else
        cout << "string rejected (error on or before position " << pos << ")" << endl;
}

// production E -> TE'
void E() {
    T(); 
    E_();
}

// production E' -> +TE' | eps
void E_() {
    if (curr_token == '+') {
        match('+');
        T(); 
        E_();
    } else {
        // do nothing
    }
}

// production T -> FT'
void T() {
    F();
    T_();
}

// production T' -> *FT' | eps
void T_() {
    if (curr_token == '*') {
        match('*');
        F(); 
        T_();
    } else {
        // do nothing
    }
}

// production F -> (E) | a
void F() {
    if (curr_token == '(') {
        match('(');
        E();
        match(')');
    } else if (curr_token == 'a') {
        match('a');
    } else {
        parse_error("F");
    }
}

int main() {
    cin >> input;
    get_next_token();
    S();
    return 0;
}
