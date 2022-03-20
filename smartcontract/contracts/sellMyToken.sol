// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./MyToken.sol";

contract sellMyToken is Ownable {
    Token public KEEY;
    Token public USDT;
    uint256 public priceRate;

    using SafeMath for uint256;

    event Buy(address buyer, uint256 amount);
    event Withdraw(uint256 amount);
    event Deposit(uint256 amount);
    event PriceChanged(uint256 oldPrice, uint256 newPrice);

    constructor(Token _KEEY, Token _USDT, uint256 _priceRate) {
        KEEY = _KEEY;
        USDT = _USDT;
        priceRate = _priceRate;
    }

    function getRemaining() internal view returns (uint256) {
        return KEEY.balanceOf(address(this));
    }

    function setPriceRate(uint256 newPriceRate) public onlyOwner{
        emit PriceChanged(priceRate, newPriceRate);
        priceRate = newPriceRate;
    }

    function getPriceRate() public view returns (uint256) {
        return priceRate;
    }

    function deposit(uint256 numberOfTokens) public {
        require(numberOfTokens <= KEEY.balanceOf(_msgSender()), "Balance is not enough");
        require(numberOfTokens > 0, "Cannot deposit 0 or smaller amount");

        KEEY.transferFrom(_msgSender(), address(this), numberOfTokens);
        emit Deposit(numberOfTokens);
    }

    function withdraw(uint256 numberOfTokens, address receiver) public onlyOwner{
        require(numberOfTokens > 0, "Cannot withdraw 0 or smaller amount");
        KEEY.transfer(receiver, numberOfTokens);
        emit Withdraw(numberOfTokens);
    }

    function withdrawAll() public onlyOwner{
        withdraw(getRemaining(), owner());
    }

    function buyKEEY(uint256 numberOfTokens) public {
        // require(numberOfTokens > getRemaining(), "Keey is not enough");
        if (numberOfTokens > getRemaining()) {
            numberOfTokens = getRemaining();
        }
        require(getRemaining() > 0, "Sold out!!");
        uint256 payment = numberOfTokens.mul(priceRate);

        USDT.transferFrom(_msgSender(), this.owner(), payment);
        KEEY.transfer(_msgSender(), numberOfTokens);
        emit Buy(_msgSender(), numberOfTokens);
    }
}