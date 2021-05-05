import parser
import eval
import os { input }
fn f(arr []int) int {
	mut sum := 0
	for n in arr {
		sum += n
	}
	return sum
}




fn main() {
	// println(call_func(voidptr(add), 1, 2))
	//println(parser.parse("(+ 1 1)"))

	// println(eval.eval(parser.parse("1")))
	// println(eval.eval(parser.parse("(+ 1 1)")))
	// println(eval.eval(parser.parse("(+ 1 100)")))
	// println(eval.eval(parser.parse("(add1 41)")))
	// println(eval.eval(parser.parse("(lambda (x) x)")))

	//println(eval.eval(parser.parse("((lambda (x) ((lambda (y) (+ x y)) 5)) 7)")))

	env := eval.create_standard_environment()
	for true {
		raw_expr := input(" > ")
		println(eval.eval_helper(parser.parse(raw_expr), env))
	}

	// println(eval.eval(parser.parse("#t")))
	// println(eval.eval(parser.parse("#f")))
	//println(eval.eval(parser.parse("(+ 1 1)")))
 
}

