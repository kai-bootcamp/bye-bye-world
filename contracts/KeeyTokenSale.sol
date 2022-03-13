// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import './KeeyToken.sol';
import './USDTToken.sol';
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract KeeyTokenSale {
    address payable public admin;
    address public funds = 0x74756DAc944FD192Bb85a8A613918e107e3dcc85;
    KeeyToken public token;
    USDTToken public usdtToken;
    uint256 public tokensSold;
    uint256 public tokenPriceUSD;
    AggregatorV3Interface internal priceFeed;

    uint256 public transactionCount;

    event Sell(address _buyer, uint256 _amount);

    struct Transaction {
        address buyer;
        uint256 amount;
    }

    mapping(uint256 => Transaction) public transaction;

    constructor(KeeyToken _token, USDTToken _usdtToken) {
        priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
        tokenPriceUSD = 10000;
        token = _token;
        usdtToken = _usdtToken;
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

    // function getKeeyTokenPriceInETH() public view returns(int) {
    //     int ethPrice = getETHPrice();
    //     return tokenPriceUSD / ethPrice;
    // }

    function buyToken(uint256 _amount) public payable {
        // int keeyTokenPriceInETH = getKeeyTokenPriceInETH();

        // Check that the buyer balance is enough
        // require(usdtToken.balanceOf(msg.sender) >= uint256(tokenPriceUSD * int(_amount)), 'Insufficient Balance');

        // Check that the sale contract provides the enough KEEY to make this transaction
        require(token.balanceOf(address(this)) >= _amount, 'Not enough KEEY to send');

        // Make sure allowance is enough 
        // require(usdtToken.allowance(msg.sender, address(this)) >= uint256(tokenPriceUSD * int(_amount)), 'Allowance is not enough');
        
        // Make sure transfer USDT from buyer to ICO SMC successfully
        require(usdtToken.transferFrom(msg.sender, funds, uint256(tokenPriceUSD * _amount)),'Transfer USDT from buyer failed');

        // Make sure token transfer successfully
        require(token.transfer(msg.sender, _amount), 'Transfer token failed');

        // Transfer the USDT of the buyer to us
        // funds.transfer(msg.value);

        tokensSold += _amount;
        transaction[transactionCount] = Transaction(msg.sender, _amount);
        transactionCount++;

        emit Sell(msg.sender, _amount);
    }

    // function endSale() public {
    //     require(msg.sender == admin);

    //     uint256 amount = token.balanceOf(address(this));
    //     require(token.transfer(admin, amount));
    //     selfdestruct(payable(admin));
    // }
}