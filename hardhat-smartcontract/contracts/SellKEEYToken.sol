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
    uint256 public priceToPay;

    uint256 public remainingAmount = 0;
    // uint public decimal = 18;
    constructor(
        
        Token _KEEYAddress,
        Token _USDTAddress,
        uint256 _priceToPay
    ) {
        KEEYAddress = _KEEYAddress;
        USDTAddress = _USDTAddress;
        
        priceToPay = _priceToPay;
        owner = msg.sender;
    }

    function initFund(uint256 totalFunding) public {
        //transfer token from owner to contract, contract have token instead of wallet user
        //Note: dont need to check 0
        require(totalFunding > 0, "totalFunding is not positive");
        require(totalFunding <= KEEYAddress.balanceOf(msg.sender), "Balance is not enough for fund");
        remainingAmount += totalFunding;
        KEEYAddress.transferFrom(msg.sender, address(this), totalFunding);
    }

    function withdraw(uint256 numTokens) public{
        //Note: dont need to check 0
        require(numTokens > 0, "Amount is not positive");
        require(numTokens <= remainingAmount, "Remaining amount in contract is not enough for withdraw");
        remainingAmount -= numTokens;
        KEEYAddress.transfer(owner, numTokens);
    }

    function withdrawAll() public{
        require(remainingAmount > 0, "Remaining amount is not positive");
        uint256 amount = remainingAmount;
        remainingAmount = 0;
        KEEYAddress.transfer(owner, amount);
    }

    function buyKEEY(uint256 amount) public {
        require(amount > 0, "Not allow non-positive amount!");
        require(remainingAmount > amount, "Amount remaining not enough!");
        console.log("Pass remain check");

        uint256 totalPayment = amount * priceToPay;
        uint256 userAllowance = USDTAddress.allowance(msg.sender, address(this));
        console.log("Allowance: ", userAllowance);

        require(userAllowance >= totalPayment, "Buyer's allowance is not enough!");
        console.log("Pass allowance");

        //Chuyen usdt tu user toi owner
        USDTAddress.transferFrom(msg.sender, owner, totalPayment);
        console.log("pass transfer USDT");
        //chuyen KEEY tu contract den user
        //Co the mat tien cua user neu remaining ko du
        remainingAmount -= amount;
        KEEYAddress.transfer(msg.sender, amount);
        console.log("pass transfer KEEY");
    }
}