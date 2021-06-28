# Toy Lisp in V
## Work in Progress
This is just a quick little project to get a working toy lisp in V!

This lisp is interpreted, it would be awesome to get a lisp->V transpiler but currently closures arent really implemented in V.

This should be a fun experiment, I hope to benchmark how this compares to other implementations of LISP in C, C++, and Rust.

### Features:

- ✔️ Numbers and basic operations on numbers
- ✔️ Booleans and basic operations on booleans
- ✔️ Lambdas
- 🚧 Strings
- 🚧 Good quoting
- 🚧 Quasiquoting

### Project Organization

Pretty simple, first we tokenize the input string into a tree of tokens, then we evaluate that tree of tokens. `parser.v` parses/tokenizes the input string and `eval.v` interprets the tree and executes some code in V accordingly.


### Get Started

#### `v run .`
Compiles and runs everything in main.

#### `v test .`
Runs all tests
