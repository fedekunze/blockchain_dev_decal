pragma solidity ^0.4.16;


contract Fibonacci {
	/** We use a dynamic programming approach to store prev computations of the
	Fibonacci sequence in a dictionary **/
	mapping (uint => uint) fib; // public by default
	fib[0] = 1;
	fib[1] = 1;

	function calculate(uint position) returns (uint result) {
		/* Add one variable to hold our greeting */
		if (fib[position] == 0){
			fib[position] = calculate(position - 1) + calculate (position - 2);
		}
		result  = fib[position]; // return result;
		/* If you declare the name of the variable in the func call you don't need
		to explicitly return it */
	}

	/* Add a fallback function to prevent contract payability and non-existent function calls */
}
