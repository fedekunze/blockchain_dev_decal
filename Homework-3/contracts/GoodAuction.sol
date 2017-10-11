pragma solidity ^0.4.15;

import "./AuctionInterface.sol";

/** @title GoodAuction */
contract GoodAuction is AuctionInterface {
	/* New data structure, keeps track of refunds owed to ex-highest bidders */
	mapping(address => uint) refunds;

	/* Bid function, shifts to push paradigm
	 * Must return true on successful send and/or bid, bidder
	 * reassignment
	 * Must return false on failure and allow people to
	 * retrieve their funds
	 */
	function bid() payable external returns(bool) {
		// YOUR CODE HERE
		highestBidder = getHighestBidder();
		highestBid = getHighestBid();
		uint value = msg.value;
		address bidder = msg.sender;
		if (value <= highestBid) return false;
		else {
			// refund previous highest bidder
			if (highestBidder != address(0) && highestBidder != bidder) refunds[highestBidder] += highestBid;
			highestBid = value;
			highestBidder = bidder;
			return true;
		}
	}

	/* New withdraw function, shifts to push paradigm */
	function withdrawRefund() external returns(bool) {
		// YOUR CODE HERE
		address sender = msg.sender;
		uint amount = refunds[sender];
		refunds[sender] = 0;
    if (amount > 0) {
      sender.transfer(amount);
			amount = 0;
			return true;
    }
		return false;
	}

	/* Allow users to check the amount they can withdraw */
	function getMyBalance() constant external returns(uint) {
		return refunds[msg.sender];
	}

	/* Give people their funds back */
	function () payable {
		// YOUR CODE HERE
		revert();
	}
}
