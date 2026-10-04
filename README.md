# English Auction

A decentralized **English Auction smart contract** for selling ERC721 NFTs through an on-chain bidding system.

The auction starts with a minimum starting bid, allows users to compete by placing higher bids, and transfers the NFT to the highest bidder when the auction ends.

## Features

* Auction ERC721 NFTs
* Set a starting bid
* 60-second auction duration
* Place ETH bids
* Automatically track the highest bidder
* Withdraw funds from previous bids
* Transfer the NFT to the winner
* Send the winning bid to the seller
* Return the NFT to the seller if there are no bids
* Emit events for auction activities

## How It Works

```text
Seller
  │
  │ Start Auction
  ▼
NFT → Auction Contract
  │
  ▼
Users Place ETH Bids
  │
  ├── Higher Bid → Previous Bidder Can Withdraw
  │
  ▼
Auction Ends
  │
  ├── Winner → Receives NFT
  │             Seller receives ETH
  │
  └── No Bids → NFT returns to Seller
```

## Main Functions

| Function     | Description                                              |
| ------------ | -------------------------------------------------------- |
| `start()`    | Starts the auction and transfers the NFT to the contract |
| `bid()`      | Places a higher ETH bid                                  |
| `withdraw()` | Withdraws funds from previous bids                       |
| `end()`      | Ends the auction and distributes the NFT and ETH         |

## Events

```solidity
event Start();
event Bid(address indexed sender, uint256 amount);
event Withdraw(address indexed bidder, uint256 amount);
event End(address indexed winner, uint256 amount);
```

These events allow external applications and block explorers to track auction activity.

## Tech Stack

* **Solidity** `^0.8.31`
* **ERC721**
* **Ethereum / EVM**
* **Foundry**

## Auction Flow

1. The seller deploys the contract with the NFT address, token ID, and starting bid.
2. The seller calls `start()` to transfer the NFT to the auction contract.
3. Users call `bid()` with an amount higher than the current highest bid.
4. Previous bidders can withdraw their outbid funds using `withdraw()`.
5. After 60 seconds, `end()` can be called.
6. The highest bidder receives the NFT and the seller receives the winning ETH bid.

## Security

This project is intended for **educational and development purposes**.

The contract should be thoroughly tested and audited before being used with real NFTs or ETH.

## License

This project is licensed under the **MIT License**.
