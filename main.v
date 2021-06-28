import parser
import eval
import os { input }

fn start_repl() {
	env := eval.create_standard_environment()
	for true {
		raw_expr := input(" > ")
		println(eval.eval_helper(parser.parse(raw_expr), env))
	}
}


fn main() {
	start_repl()
}
