import parser
import eval
fn f(arr []int) int {
	mut sum := 0
	for n in arr {
		sum += n
	}
	return sum
}



fn main() {
	println(eval.eval(parser.parse("1")))
	println(eval.eval(parser.parse("x")))
	println(eval.eval(parser.parse("#t")))
	println(eval.eval(parser.parse("#f")))
	//println(eval.eval(parser.parse("(+ 1 1)")))

}

