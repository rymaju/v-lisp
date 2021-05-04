module eval
import parser

type Expression = int | string | bool | []Expression // or a function...


type Environment = Frame | Empty

struct Empty {}
struct Frame {
	parent Environment
	mapping map[string]Expression
}


struct Function {
	pointer int
}

fn add(x int, y int) Expression {
	return Expression(x+y)
}

fn create_standard_environment() Frame {
	mapping := map{
		'x': Expression(42)
		'y': Expression(true)
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
			mut evaluated := []Expression{}
			for i in 0 .. s_exp.len {
				evaluated[i] = eval_helper(s_exp[i], env)
			}

			// typecheck: must be of form (operator [operand ...]), i.e. (+ 1 1)
			return Expression(false)

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