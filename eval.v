module eval
import parser

type Expression = int | string | bool | []Expression | Function // or a function...

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


fn add(args []Expression) Expression {
	mut sum := 0

	for expr in args {
		sum += expression_to_int(expr)
	}
	
	return sum
}

fn sub(args []Expression) Expression {
	if args[0] is int && args[1] is int {
		return Expression(expression_to_int(args[0])+expression_to_int(args[1]))
	}
	panic("Error: args must be 2 ints")
}


fn create_standard_environment() Frame {
	mapping := map{
		'x': Expression(42)
		'y': Expression(true)
		'+': Expression(Function(add))
	}
	return Frame{Empty{}, mapping}
}

// Reduces the incoming s expression into a valid lisp expression
pub fn eval(s_exp parser.SExp) Expression {
	return eval_helper(s_exp, create_standard_environment())
}

// Helper for eval, accumulates the current environment
// TODO: also keep track of store for mutation
fn eval_helper(s_exp parser.SExp, env Environment) Expression {
	match s_exp {
		[]parser.SExp {
			evaluated := s_exp.map(eval_helper(it, env))
			f := expression_to_function(evaluated[0])
			return f(evaluated[1..], env)
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