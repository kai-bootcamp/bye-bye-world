// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import './KeeyToken.sol';
import './USDTToken.sol';
import "hardhat/console.sol";

contract KeeyTokenSale {
    address payable public admin;
    KeeyToken public token;
    USDTToken public usdtToken;
    uint256 public tokensSold;
    uint256 public tokenPriceUSD;

    uint256 public transactionCount;

    event Sell(address _buyer, uint256 _amount);
    event EndSale(uint256 _amount);

    struct Transaction {
        address buyer;
        uint256 amount;
    }

    mapping(uint256 => Transaction) public transaction;

    constructor(KeeyToken _token, USDTToken _usdtToken) {
        tokenPriceUSD = 10000;
        token = _token;
        usdtToken = _usdtToken;
        admin = payable(msg.sender);
    }


    function buyToken(uint256 _amount, address payable buyer) public payable {
        console.log('Address admin: %s, this: %s, msg.sender: %s', admin, address(this), msg.sender);
        // Check that the sale contract provides the enough KEEY to make this transaction
        require(token.balanceOf(address(this)) >= _amount, 'Not enough KEEY to send');

        require(usdtToken.allowance(buyer, admin) >= uint256(tokenPriceUSD * _amount), 'Not enough allowance');
        // Make sure transfer USDT from buyer to ICO SMC successfully
        require(usdtToken.transferFrom(buyer, admin, uint256(tokenPriceUSD * _amount)),'Transfer USDT from buyer failed');
        console.log("Transfer USDT from Buyer to Admin successfully");
        // Make sure token transfer successfully
        require(token.transfer(buyer, _amount), 'Transfer token failed');
        console.log("Transfer token from Smc Sale to Buyer successfully");

        tokensSold += _amount;
        transaction[transactionCount] = Transaction(buyer, _amount);
        transactionCount++;

        emit Sell(buyer, _amount);
    }

    function endSale() public {
        require(msg.sender == admin);
        // Return the tokens that were left inside of the sale contract
        uint256 amount = token.balanceOf(address(this));
        require(token.transfer(admin, amount));

        emit EndSale(amount);
        
    }
}