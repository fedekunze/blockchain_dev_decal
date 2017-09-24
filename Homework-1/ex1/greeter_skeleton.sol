pragma solidity ^0.4.13;


contract greeter {
	/* Add one variable to hold our greeting */
	address owner; // address
	string greeting;
	uint public times;

	// Constructor function
	function greeter(string _greeting) public {
		/* Write one line of code for the contract to set our greeting */
		owner = msg.sender; // To set the owner of the contract
		greeting = _greeting;

	}

	function greet() constant returns (string)  {
		/* Write one line of code to allow the contract to return our greeting */
		times ++;
		return  greeting;
	}

	function count() constant returns (uint){
		return times;
	}

	// Kill function to recover funds
	function kill() {
		if (msg.sender == owner){
			suicide(owner);	// kills contract and sends funds back to 'owner'
		}
	}

}
