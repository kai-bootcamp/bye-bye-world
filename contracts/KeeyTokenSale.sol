// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import './KeeyToken.sol';
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract KeeyTokenSale {
    address payable public admin;
    address payable private ethFunds = payable(0x74756DAc944FD192Bb85a8A613918e107e3dcc85);
    KeeyToken public token;
    uint256 public tokensSold;
    int public tokenPriceUSD;
    AggregatorV3Interface internal priceFeed;

    uint256 public transactionCount;

    event Sell(address _buyer, uint256 _amount);

    struct Transaction {
        address buyer;
        uint256 amount;
    }

    mapping(uint256 => Transaction) public transaction;

    constructor(KeeyToken _token) {
        priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
        tokenPriceUSD = 10;
        token = _token;
        admin = payable(msg.sender);
    }

    function getETHPrice() public view returns(int) {
                (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();

        //Chain link return price in GWei

        return (price / 10**8);
    }

    function getKeeyTokenPriceInETH() public view returns(int) {
        int ethPrice = getETHPrice();
        return tokenPriceUSD / ethPrice;
    }

    function buyToken(uint256 _amount) public payable {
        int keeyTokenPriceInETH = getKeeyTokenPriceInETH();

        // Check that the buyer sends the enough ETH
        require(int(msg.value) >= keeyTokenPriceInETH * int(_amount));

        // Check that the sale contract provides the enogh ETH to make this transaction
        require(token.balanceOf(address(this)) >= _amount);

        // Make sure token transfer successfully
        require(token.transfer(msg.sender, _amount));

        // Transfer the ETH of the buyer to us
        ethFunds.transfer(msg.value);

        tokensSold += _amount;
        transaction[transactionCount] = Transaction(msg.sender, _amount);
        transactionCount++;

        emit Sell(msg.sender, _amount);
    }

    function endSale() public {
        require(msg.sender == admin);

        uint256 amount = token.balanceOf(address(this));
        require(token.transfer(admin, amount));
        selfdestruct(payable(admin));
    }
}