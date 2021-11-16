// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import './KeeyToken.sol';


contract Vendor {
    KEEYToken public keeyToken;
    // token price for USDT
    uint256 public tokensPerUSDT = 0.0001;

     // Event that log buy operation
    event BuyTokens(address buyer, uint256 amountOfUSDT, uint256 amountOfTokens);

  /**
  * @notice Allow users to buy token for USDT
  */
  function buyTokens() public payable returns (uint256 tokenAmount) {
    require(msg.value > 0, "Send USDT to buy some tokens");

    uint256 amountToBuy = msg.value * tokensPerUSDT;

    // check if the Vendor Contract has enough amount of tokens for the transaction
    uint256 vendorBalance = keeyToken.balanceOf(address(this));
    require(vendorBalance >= amountToBuy, "Vendor contract has not enough tokens in its balance");

    // Transfer token to the msg.sender
    (bool sent) = keeyToken.transfer(msg.sender, amountToBuy);
    require(sent, "Failed to transfer token to user");

    // emit the event
    emit BuyTokens(msg.sender, msg.value, amountToBuy);

    return amountToBuy;
  }
}