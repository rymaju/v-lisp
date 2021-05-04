module parser

// Represents an S-Expression (aka Abstract Syntax Tree / Tokens)
pub type SExp = Atom | []SExp

pub type Atom = Identifier | int | bool 



pub struct Identifier {
pub:
	name string
}

// Parses a string into a valid S-Expression
pub fn parse(str string) SExp {
	return parse_helper(str, 0).result
}

// Required because returning sum type as one of multiple values is broken
// https://github.com/vlang/v/issues/10003
struct ParseResult {
	result SExp
	next int
}

// Helper for parse, accumulates idx, which represents the index of str to start parsing
fn parse_helper(str string, idx int) ParseResult {
	parser_delimiters := [`(`, `)`, ` `]
	whitespace := [` `]
	if str.len == idx {
		//ERROR EOF
		panic("Error: Unexpected EOF at string index: $idx")
	}

	first_char := str[idx]
	if first_char == `(` {
		mut ptr := idx
		ptr += 1
		mut stack := []SExp{}

		for str[ptr] != `)` {
			result := parse_helper(str, ptr)
			stack << result.result
			ptr = result.next
		}
		ptr += 1

		return ParseResult{stack, ptr}
	}

	// else its just a SExp
	mut ptr := idx
	for (ptr < str.len && str[ptr] in whitespace) {
		ptr += 1
	}
	start := ptr
	for ptr < str.len && str[ptr] !in parser_delimiters {
		ptr += 1
	}
	end := ptr
	for (ptr < str.len && str[ptr] in whitespace) {
		ptr += 1
	}

	raw_atom := str[start..end]

	if is_numeric(raw_atom) {
		return ParseResult{Atom(raw_atom.int()), ptr}
	}
	else if is_boolean(raw_atom) {
		return ParseResult{Atom(str_to_bool(raw_atom)), ptr}
	}
	else {
		return ParseResult{Atom(Identifier{raw_atom}), ptr}
	}
}

fn is_numeric(str string) bool {
	numeric_chars := [`1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`, `0`]
	for ch in str {
		if ch !in numeric_chars{
			return false
		}
	}
	return true
}

fn is_boolean(str string) bool {
	return str == "#t" || str == "#f"
}

fn str_to_bool(str string) bool {
	return str == "#t"
}
