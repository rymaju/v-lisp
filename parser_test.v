module parser
fn test_parser() {
	assert(parse("(+ 1 1)") == SExp([SExp(Atom(Identifier{'+'})), SExp(Atom(1)), SExp(Atom(1))]))
	assert(parse("(+ 123 456)") == SExp([SExp(Atom(Identifier{'+'})), SExp(Atom(123)), SExp(Atom(456))]))
	assert(parse("(+ 123 456   #t     )") == SExp([SExp(Atom(Identifier{'+'})), SExp(Atom(123)), SExp(Atom(456)), SExp(Atom(true))]))
}