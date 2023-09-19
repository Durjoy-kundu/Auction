// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AuctionContract {
    struct AuctionItem {
        string name;
        string description;
        address highestBidder;
        uint highestBid;
    }

      // Mapping to store auction items using their IDs.
    mapping(uint256 => AuctionItem) public items;

    // Create a variable to keep track of the total number of items.
    uint256 public itemCount;

    // Modifier to check if an item with a given ID exists.
    modifier itemExists(uint256 itemId) {
        require(itemId > 0 && itemId <= itemCount, "Item does not exist");
        _;
    }

    // Function to add a new item to the auction.
    function addItem(string memory name, string memory description) public {
        itemCount++;
        items[itemCount] = AuctionItem(name, description, address(0), 0);
    }

    // Function to place a bid on a specific item.
    function placeBid(uint256 itemId) public payable itemExists(itemId) {
        require(msg.value > items[itemId].highestBid, "Bid must be higher than the current highest bid");

        // Refund the previous highest bidder.
        if (items[itemId].highestBidder != address(0)) {
            payable(items[itemId].highestBidder).transfer(items[itemId].highestBid);
        }

        // Update the highest bidder and bid amount.
        items[itemId].highestBidder = msg.sender;
        items[itemId].highestBid = msg.value;
    }

    // Function to determine the current highest bidder and winning bid for a specific item.
    function getHighestBidder(uint256 itemId) public view itemExists(itemId) returns (address, uint256) {
        return (items[itemId].highestBidder, items[itemId].highestBid);
    }

    // Function to retrieve information about a specific item.
    function getItemInfo(uint256 itemId) public view itemExists(itemId) returns (string memory, string memory, address, uint256) {
        AuctionItem storage item = items[itemId];
        return (item.name, item.description, item.highestBidder, item.highestBid);
    }
}


