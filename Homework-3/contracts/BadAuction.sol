pragma solidity ^0.4.15;

import "./AuctionInterface.sol";

/** @title BadAuction */
contract BadAuction is AuctionInterface {
	/* Bid function, vulnerable to attack
	 * Must return true on successful send and/or bid,
	 * bidder reassignment
	 * Must return false on failure and send people
	 * their funds back
	 */
	function bid() payable external returns (bool) {
		// YOUR CODE HERE
		uint value = msg.value;
		require(value > getHighestBid());
		// refund previous highest bidder
		if (highestBidder != address(0)) getHighestBidder().transfer(getHighestBid());
		highestBidder = msg.sender;
		highestBid = value;
		return true;
	}

	/* Give people their funds back */
	function () payable {
		// YOUR CODE HERE
		revert();
	}
}
