module eval
import parser

fn test_eval() {
	assert(eval.eval(parser.parse("(+ 1 1)")) == Expression(2))
	assert(eval.eval(parser.parse("(+ 1 100)")) == Expression(101))
}

