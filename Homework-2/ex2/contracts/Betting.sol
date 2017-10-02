pragma solidity ^0.4.15;

contract Betting {
	/* Standard state variables */
	address public owner;
	address public gamblerA;
	address public gamblerB;
	address public oracle;
	uint[] outcomes;

	/* Structs are custom data structures with self-defined parameters */
	struct Bet {
		uint outcome;
		uint amount;
		bool initialized;
	}

	/* Keep track of every gambler's bet */
	mapping (address => Bet) bets;
	/* Keep track of every player's winnings (if any) */
	mapping (address => uint) winnings;

	/* Add any events you think are necessary */
	event BetMade(address gambler);
	event BetClosed();
	event BetsReseted();
	event WinningAmounts(address accountAddress, uint amount);

	/* Uh Oh, what are these? */
	modifier OwnerOnly() {
		if (owner == msg.sender) {
			_;
		}
		/*require(owner == msg.sender);
		require((owner != gamblerA) && (owner != gamblerB));
		 _;*/
	 }

	modifier OracleOnly() {
		if (oracle == msg.sender) {
			_;
		}
		/*require(oracle == msg.sender);
		_;*/
	}

	modifier GamblerOnly() {
		if ((msg.sender != oracle) && (msg.sender != owner)) {
			_;
		}
		/*require(msg.sender != oracle);
		require(msg.sender != owner);
		_;*/
	}

	// Prevents gambler to make more than one bet
	modifier OneBetOnly() {
		if (bets[msg.sender].initialized == false){
			_;
		}
		/*require(bets[msg.sender].initialized == false);
		_;*/
	}

	modifier DistinctGamblers() {
		if (gamblerA != gamblerB) {
			_;
		}
		/*require(gamblerA != gamblerB);
		_;*/
	}

	modifier BetsPlaced() {
		if (bets[gamblerA].initialized && bets[gamblerB].initialized) {
			_;
		}
		/*require(bets[gamblerA].initialized && bets[gamblerB].initialized);
		_;*/
	}


	/* Constructor function, where owner and outcomes are set */
	function BettingContract(uint[] _outcomes) {
		owner = msg.sender;
		outcomes = _outcomes;
	}

	/* Owner chooses their trusted Oracle */
	function chooseOracle(address _oracle) OwnerOnly() returns (address) {
		oracle = _oracle;
		return oracle;
	}

	/* Gamblers place their bets, preferably after calling checkOutcomes */
	function makeBet(uint _outcome) payable GamblerOnly() OneBetOnly() returns (bool) {
		if ((gamblerA == address(0)) && (gamblerB == address(0))) {
			gamblerA = msg.sender;
		} else if ((gamblerA != address(0)) && (gamblerB == address(0))) {
			gamblerB = msg.sender;
		}
		bets[msg.sender] = Bet({
				outcome: _outcome,
				amount: msg.value,
				initialized: true
		});
		BetMade(msg.sender);
		return bets[msg.sender].initialized;
	}

	/* The oracle chooses which outcome wins */
	function makeDecision(uint _outcome)
		OracleOnly()
		DistinctGamblers()
		BetsPlaced()
	{
		/* If all gamblers bet on the same outcome, reimburse all gamblers their funds
		If no gamblers bet on the correct outcome, the oracle wins the sum of the funds
		*/
		if (bets[gamblerA].outcome == bets[gamblerB].outcome) {
			// Tie. reimburse all funds
			winnings[gamblerA] += bets[gamblerA].amount;
			WinningAmounts(gamblerA, bets[gamblerA].amount);
			winnings[gamblerB] += bets[gamblerB].amount;
			WinningAmounts(gamblerB, bets[gamblerB].amount);
		}
		else if ((bets[gamblerA].outcome != _outcome) && (bets[gamblerB].outcome != _outcome)) {
			// Oracle Wins
			winnings[oracle] += (bets[gamblerA].amount + bets[gamblerB].amount);
			WinningAmounts(gamblerA, 0);
			WinningAmounts(gamblerB, 0);
		}
		else if ((bets[gamblerA].outcome == _outcome) && (bets[gamblerB].outcome != _outcome)) {
			// Gambler A wins
			winnings[gamblerA] += (bets[gamblerA].amount + bets[gamblerB].amount);
			WinningAmounts(gamblerA, bets[gamblerA].amount + bets[gamblerB].amount);
			WinningAmounts(gamblerB, 0);
		}
		else {
			// Gambler B wins
			winnings[gamblerB] += (bets[gamblerA].amount + bets[gamblerB].amount);
			WinningAmounts(gamblerA, 0);
			WinningAmounts(gamblerB, bets[gamblerA].amount + bets[gamblerB].amount);
		}
		contractReset();
		BetClosed();
	}

	/* Allow anyone to withdraw their winnings safely (if they have enough) */
	function withdraw(uint withdrawAmount) returns (uint remainingBal) {
		remainingBal = winnings[msg.sender];
		if (remainingBal > withdrawAmount) {
			remainingBal -= withdrawAmount;
			winnings[msg.sender] -= withdrawAmount;
			msg.sender.transfer(withdrawAmount); // reverts if error
		}
	}

	/* Allow anyone to check the outcomes they can bet on */
	function checkOutcomes() constant returns (uint[]) {
		return outcomes;
	}

	/* Allow anyone to check if they won any bets */
	function checkWinnings() constant returns(uint) {
		return winnings[msg.sender];
	}

	/* Call delete() to reset certain state variables. Which ones? That's upto you to decide */
	function contractReset() private {
		delete(bets[gamblerA]);
		delete(bets[gamblerB]);
		BetsReseted();
	}

	/* Fallback function */
	function() {
		revert();
	}
}
