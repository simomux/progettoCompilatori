# Assignment for my front-end compilers class A.Y. 2023-2024

## Objective

Create a front-end compiler for Kaleidoscope extending the skeleton template from a modified version of the code from [My First Language Frontend with LLVM Tutorial](https://llvm.org/docs/tutorial/MyFirstLanguageFrontend/index.html).

The assignment is divided in 4 parts, each one giving you a grammar and requiring the implementation of it and of the necessaries AST nodes.

## Requirements

LLVM-16 is required for the project to run, to install check [this](https://releases.llvm.org/download.html).

Once you have installed the correct version of LLVM you can run the front-end.

## How to run

Simply compile using:
```bash
make all
```
This will compile each necessary file for the project to run.

## How to test
To test the front-end various files are present in `test_progetto`.

Simply run:
```bash
cd test_progetto && make all
```

The command should create and executable for each file, according to the level of grammar that has been developed.
To check which files are necessaries for which level of grammar consult `test_progetto/README`.


## Grammar

### First level grammar

Implements assignment logic, definition of global variables and modified `BlockExpAST` to allow for multiple statements inside a block.

<details><summary>Grammar</summary>

```bison
% start startsymb;

startsymb:
	program 

program:
	% empty
| top ";" program % left ":";

top:
	% empty
| definition
|	external
| globalvar

definition:
	"def" proto block

external:
	"extern" proto

proto:
	"id" "(" idseq ")"

globalvar :
" global " "id"

idseq :
	% empty
|	"id" idseq

%left ":";
%left " <" "==";
%left "+" " -";
%left "*" "/";

stmts :
	stmt
|	stmt ";" stmts

stmt :
	assignment
|	block
|	exp

assignment
	"id" "=" exp

block:
	"{" stmts "}"
|	"{" vardefs ";" stmts "}"

vardefs:
	binding
| vardefs ";" binding

binding:
	"var" "id" initexp

exp:
	exp "+" exp
| exp " -" exp
| exp "*" exp
| exp "/" exp
| idexp
| "(" exp ")"
| "number"
| expif

initexp:
	%empty
| "=" exp

expif:
 	condexp "?" exp ":" exp

condexp:
	exp "<" exp
|	exp "==" exp

idexp:
	"id"
|	"id" "(" optexp ")"

optexp:
	%empty
|	explist

explist:
	exp
| exp "," explist
```

</details>


### Second level grammar

Implements rules and logic for `if` construct, `for` loops.

```bison
stmt:
	assignment
| block
| ifstmt
| forstmt
| exp

ifstmt:
	"if" "(" condexp ")" stmt
| "if" "(" condexp ")" stmt " else " stmt

forstmt:
	"for" "(" init ";" condexp ";" assignment ")" stmt

init:
	binding
| assignment
```

### Third level grammar

Implements boolean operators `and`, `or` and `not` for consecutive conditional expressions.

```bison
condexp:
	relexp
| relexp "and" condexp
| relexp "or" condexp
| "not" condexp
| "(" condexp ")"

relexp:
	exp "<" exp
| exp "==" exp
```

### Fourth level grammar

TODO

```bison
binding:
	"var" "id" initexp
| "var" "id" "[" "number" "]"
| "var" "id" "[" "number" "]" "=" "{" explist "}"

idexp:
	"id"
|	"id" "(" optexp ")"
|	"id" "[" exp "]"

assignment:
	"id" "=" exp
|	"id" "[" exp "]" "=" exp
```