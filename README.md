# scanner for μGo in Lex
contributed by <`bauuuu1021`>
## Execution
install lex package first. `$sudo apt-get install lex`.<br>
`$make` the project to get exe file `myscanner`. Execute it by `$./myscanner <μGo_file>`. 
## Basic Features
- [x] Print the recognized token on a separate line and discard whitespace and undefined
character sets. (50pt)
- [x] Count the lines of code in the given program. (10pt)
- [x] Implement the symbol table functions.
    * create_symbol() (10pt)
        * **I implement this function by declared a global variable**
        * Line:68~74
        * Set max number of variables as 1000 
        * Index number of the first variable is **1**
    * insert_symbol() (10pt)
    * lookup_symbol() (10pt)
        * Return index number if found the variable; otherwise, return 0.
    * dump_symbol() (10pt)
## Advanced features
- [x] Discard C and C++ type comment. (10pt)
- [x] Count the comment lines. (10pt)
- [x] Syntax error check. (10pt)
    * Undeclared variables
    * Redefined variables
 