module eval
import parser

fn test_eval() {
	assert(eval.eval(parser.parse("(+ 1 1)")) == Expression(2))
	assert(eval.eval(parser.parse("(+ 1 100)")) == Expression(101))
	assert(eval.eval(parser.parse("((lambda (x) x) 10)")) == Expression(10))
	assert(eval.eval(parser.parse("((lambda (x) ((lambda (y) (+ x y)) 5)) 7)")) == Expression(12))
}

