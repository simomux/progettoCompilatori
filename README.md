# Assignment for my front-end compilers class A.Y. 2023-2024

## Objective

Create a front-end compiler for Kaleidoscope extending the skeleton template from a modified version of the code from [My First Language Frontend with LLVM Tutorial](https://llvm.org/docs/tutorial/MyFirstLanguageFrontend/index.html).

The assignment is divided in 4 parts, each one giving you a grammar and reuqiring the implementation of it and of the necessaries AST nodes.

### First level grammar

Fisrt part requires to implement assignment logic for variables.

<details><summary>Grammar</summary>

```bison
% start startsymb;

startsymb:
	program 

program:
	% empty
| 	top ";" program % left ":";

top:
	% empty
| 	definition
| 	external
| 	globalvar

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
| 	"{" vardefs ";" stmts "}"

vardefs:
	binding
| 	vardefs ";" binding

binding:
	"var" "id" initexp

exp:
	exp "+" exp
| 	exp " -" exp
| 	exp "*" exp
| 	exp "/" exp
| 	idexp
| 	"(" exp ")"
| 	"number"
| 	expif

initexp:
	%empty
| 	"=" exp

expif:
 	condexp "?" exp ":" exp

condexp:
	exp "<" exp
| 	exp "==" exp

idexp:
	"id"
|	"id" "(" optexp ")"

optexp:
	%empty
|	explist

explist:
	exp
| 	exp "," explist
```

</details>


### Second level grammar

Implements rules and logic for if construct, for loops and initializations.

```bison
stmt:
	assignment
| 	block
| 	ifstmt
| 	forstmt
| 	exp

ifstmt:
	"if" "(" condexp ")" stmt
| 	"if" "(" condexp ")" stmt " else " stmt

forstmt:
	"for" "(" init ";" condexp ";" assignment ")" stmt

init:
	binding
| 	assignment
```

### Third level grammar

...

```bison
condexp:
relexp
| 	relexp "and" condexp
| 	relexp "or" condexp
| 	"not" condexp
| 	"(" condexp ")"

relexp:
	exp "<" exp
| 	exp "==" exp
```

### Fourth level grammar

...

```bison
binding:
	"var" "id" initexp
| 	"var" "id" "[" "number" "]"
| 	"var" "id" "[" "number" "]" "=" "{" explist "}"

idexp:
	"id"
| 	"id" "(" optexp ")"
| 	"id" "[" exp "]"

assignment:
	"id" "=" exp
| 	"id" "[" exp "]" "=" exp
```