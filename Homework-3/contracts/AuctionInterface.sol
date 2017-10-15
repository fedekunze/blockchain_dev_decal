pragma solidity ^0.4.15;

/** @title AuctionInterface */
contract AuctionInterface {
	address public highestBidder;
	uint public highestBid;
	function bid() payable external returns (bool);
	function getHighestBidder() public constant returns (address) {
		return highestBidder;
	}
	function getHighestBid() public constant returns (uint) {
		return highestBid;
	}
}
