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
	// println(call_func(voidptr(add), 1, 2))
	println(parser.parse("(+ 1 1)"))

	// println(eval.eval(parser.parse("1")))
	println(eval.eval(parser.parse("(+ 1 1)")))
	println(eval.eval(parser.parse("(+ 1 100)")))

	// outer := 10
	// nums := [1,2,3]
	
	// println(nums.map(it + outer)) // works just fine :D

	// println(nums.map(fn (inner int) int { return inner + outer})) // Error: Unidentified ident "outer"
	
	


	// println(eval.eval(parser.parse("#t")))
	// println(eval.eval(parser.parse("#f")))
	//println(eval.eval(parser.parse("(+ 1 1)")))

}

