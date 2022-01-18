// SPDX-License-Identifier: MIT
pragma solidity >=0.6.6 <0.9.0;

// import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/IERC20.sol";
/*
How to buy tokens
USDT approve (amount * rate)
KEEY approve (amount)
_safeTransferFrom(USDT)
*/
import "./Token.sol";
import "./Owned.sol";

contract SellKEEYToken is Owned {
    using SafeMath for uint256;
    Token public USDTAddress;
    Token public KEEYAddress;
    uint256 public payToPrice;

    uint256 remainingAmount;
    // uint public decimal = 18;
    constructor(
        
        Token _KEEYAddress,
        Token _USDTAddress,
        uint256 _payToPrice
    ) {
        KEEYAddress = _KEEYAddress;
        USDTAddress = _USDTAddress;
        
        payToPrice = _payToPrice;
        remainingAmount = KEEYAddress.balanceOf(msg.sender);
        owner = msg.sender;
    }

    function  initFund() public {
        KEEYAddress.transferFrom(msg.sender, address(this), remainingAmount);
    }


    function buyKEEY(uint256 amount) public {
        require(amount > 0);
        require(remainingAmount > amount);
        console.log("pass remain");
        uint256 totalPayment = amount * payToPrice;
        uint256 userAllowance = USDTAddress.allowance(msg.sender, address(this));
        console.log(" allowance: ", userAllowance);
        require(userAllowance >= totalPayment, "Need more USDT");
        console.log("pass allowance");
        //Chuyen usdt tu user toi contract
        USDTAddress.transferFrom(msg.sender, address(this), totalPayment);
        console.log("pass transfer USDT");
        //chuyen KEEY tu contract den user
        KEEYAddress.transfer(msg.sender, amount);
        console.log("pass transfer KEEY");
        remainingAmount -= amount;

    }

}