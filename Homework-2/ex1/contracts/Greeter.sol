pragma solidity ^0.4.11;
contract Greeter {

    string greeting; //global variable that our greeter will say when poked
    address owner;
    /*
     * Constructor function
     */
    /// @dev Contract constructor that sets the global `greeting` variable
    /// @param _greeting A String value to set to the global `greeting`
    function greeter(string _greeting) public {
      owner = msg.sender; // To set the owner of the contract
      greeting = _greeting;
    }

    /*
     * Greet function
     */
    /// @dev returns the String value stored in the global `greeting` variable
    function greet() constant returns (string) {
      return greeting;
    }

    // Kill function to recover funds
  	function kill() {
  		if (msg.sender == owner){
  			suicide(owner);	// kills contract and sends funds back to 'owner'
  		}
  	}

}
