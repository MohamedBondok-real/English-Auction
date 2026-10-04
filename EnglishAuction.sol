//SPDX-License-Identifier: MIT
pragma solidity ^0.8.31;

interface IERC721 {
    function safeTransferFrom (address from, address to, uint256 tokenId)external;
    function transferFrom (address,address,uint256)external;
}

contract EnglishAuction {
    event Start();
    event Bid(address indexed sender, uint256 amount);
    event Withdraw(address indexed bidder, uint256 amount);
    event End(address indexed winner, uint256 amount);

    IERC721 public nft;
    uint256 public nftId;

    address payable public seller;
    uint256 public endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint256 public highestBid;
    mapping (address => uint256) public bids;

    constructor (address _nft, uint256 _nftId, uint256 _startingBid) {
        nft = IERC721(_nft);
        nftId = _nftId;

        seller = payable (msg.sender);
        highestBid = _startingBid;
    }

    function start ()external {
        require(!started, "Strated");
        require(msg.sender == seller, "Not Seller");

        nft.safeTransferFrom(msg.sender, address(this), nftId);
        started = true;
        endAt = block.timestamp + 60;

        emit Start();
    }

    function bid () external payable {
        require(started, "Not Started");
        require(block.timestamp < endAt, "Has Ended");
        require(msg.value > highestBid, "BiddingValue < HighestBid");

        if (highestBidder != address(0)){
            bids[highestBidder] += highestBid; 
        }
        highestBidder = msg.sender;
        highestBid = msg.value;

        emit Bid (highestBidder, highestBid);
    }

    function withdraw() external {
        uint256 balance = bids[msg.sender];
        bids[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: balance}("");
        require(success, "Transfer Failed");

        emit Withdraw(msg.sender, balance);
    }

    function end () external {
        require(started, "Not Started");
        require(block.timestamp >= endAt, "Not Ended");
        require(!ended, "Ended");

        ended = true;

        if(highestBidder != address(0)){
            nft.safeTransferFrom(address(this), highestBidder, nftId);
            (bool success, ) = payable(seller).call{value: highestBid}("");
            require(success, "Transfer Failed");
        }
        else{
            nft.safeTransferFrom(address(this), seller, nftId);
        }
        emit End (highestBidder, highestBid);
    }
}