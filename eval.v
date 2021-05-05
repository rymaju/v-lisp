module eval
import parser

type Expression = int | string | bool | []Expression | Function | Closure

fn expression_to_string(e Expression) string {
	match e {
		string {
			return e
		}
		else {
			panic("die")
		}
	}
}

fn expression_to_int(e Expression) int {
	match e {
		int {
			return e
		}
		else {
			panic("die")
		}
	}
}


// fn sexp_to_ident(sexp parser.SExp) Identifier {
// 	match sexp {
// 		Identifier{
// 			return sexp
// 		}
// 		else {
// 			panic("die")
// 		}
// 	}
// }

fn expression_to_function(e Expression) Function {
	match e {
		Function {
			return e
		}
		else {
			panic("die")
		}
	}
}

type Environment = Frame | Empty

struct Empty {}
struct Frame {
	parent Environment
	mapping map[string]Expression
}


type Function = fn(args []Expression, env Environment)  Expression


struct Closure {
	param_labels []string
	thunk parser.SExp
}

fn apply_closure(params []Expression, closure Closure, env Environment) Expression {
	// map labels and params 1:1 and build a new env frame from it
	// then eval witg env and thunk and return result
	
	mut mapping := map[string]Expression{}

	if params.len != closure.param_labels.len {
		panic("Error: Number of arguments does not match function definition")
	}

	for i in 0..params.len {
		
		mapping[closure.param_labels[i]] = params[i]
	}

	return eval_helper(closure.thunk, Frame{env, mapping})
}



fn add(args []Expression) Expression {
	mut sum := 0

	for expr in args {
		sum += expression_to_int(expr)
	}

	return sum
}

fn sub(args []Expression) Expression {
	mut sum := 0

	for expr in args {
		sum -= expression_to_int(expr)
	}

	return sum
}


fn is_atom_lambda(a parser.Atom) bool {
	match a {
		parser.Identifier {
			return a.name == 'lambda'
		}
		else {
			return false
		}
	}
}
fn is_sexp_lambda(sexp parser.SExp) bool {
	match sexp {
		parser.Atom {
			return is_atom_lambda(sexp)
		}
		else {
			return false
		}
	}
}

fn extract_arg_labels(sexp parser.SExp) []string {
	match sexp {
		[]parser.SExp {
			return extract_arg_labels_list(sexp)
		}
		else {
			panic("die")
		}
	}
}

fn extract_arg_labels_list(sexp []parser.SExp) []string {
	return sexp.map(sexp_to_identifier(it).name)
}

fn sexp_to_identifier(sexp parser.SExp) parser.Identifier {
	match sexp {
		parser.Atom {
			return atom_to_identifier(sexp)
		}
		else {
			panic("die")
		}
	}
}

fn atom_to_identifier(a parser.Atom) parser.Identifier {
	match a {
		parser.Identifier {
			return a
		}
		else {
			panic("die")
		}
	}
}


fn is_lambda_form(sexp []parser.SExp) bool {
	return is_sexp_lambda(sexp[0])
}


pub fn create_standard_environment() Frame {

	mapping := map{
		'x': Expression(42)
		'y': Expression(true)
		'+': Expression(Function(add))
		'add1': Expression(Closure{["a"], parser.parse("(+ 1 a)")  })
		// TODO: implement arithmetic functions
		// TODO: implement boolean functions
	}
	return Frame{Empty{}, mapping}
}

// Reduces the incoming s expression into a valid lisp expression
pub fn eval(s_exp parser.SExp) Expression {
	return eval_helper(s_exp, create_standard_environment())
}


// Helper for eval, accumulates the current environment
// TODO: also keep track of store for mutation
pub fn eval_helper(s_exp parser.SExp, env Environment) Expression {
	match s_exp {
		[]parser.SExp {
			if is_lambda_form(s_exp) {
				args := extract_arg_labels(s_exp[1])
				body := s_exp[2]
				return Expression(Closure{args, body})
			}
			// TODO: Implement define

			// TODO: Implement if

			
			// TODO: use real s-expressions (linked lists) to allow proper pairs, not vectors
			evaluated := s_exp.map(eval_helper(it, env))

			operator := evaluated[0]
			if operator is Function {
				f := expression_to_function(operator)
				return f(evaluated[1..], env)
			}
			else if operator is Closure {
				return apply_closure(evaluated[1..], operator, env)
			}
			else {
				panic("Error: $operator is not a function")
			}
		}
		parser.Atom {
			match s_exp {
				parser.Identifier {
					return lookup(s_exp, env)
				}
				int {
					return Expression(int(s_exp))
				}
				bool {
					return Expression(s_exp == true)
				}
			}
		}
	}
	return Expression(1)
}

fn lookup(id parser.Identifier, env Environment) Expression {
	match env {
		Frame {
			if id.name in env.mapping {
				return env.mapping[id.name]
			}
			else {
				return lookup(id, env.parent)			
			}
		}
		Empty {
			panic("Error: Unbound reference to $id.name")
		}
	}
}