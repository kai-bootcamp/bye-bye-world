// SPDX-License-Identifier: MIT
pragma solidity >=0.6.6 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/IERC20.sol";
import "./IERC20.sol";

/*
How to buy tokens
USDT approve (amount * rate)
KEEY approve (amount)
_safeTransferFrom(USDT)
*/
//Address1: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
//Address2: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2

contract TokenSwap {
    IERC20 public USDT;
    address public owner1;
    uint public amount1 = 0;
    IERC20 public KEEY;
    address public owner2;
    uint public amount2 = 0;
    uint public rate = 10000;
    uint public decimal = 18;
    constructor(
        address _USDT,
        address _owner1,
        address _KEEY,
        address _owner2
    ) {
        USDT = IERC20(_USDT);
        owner1 = _owner1;
        KEEY = IERC20(_KEEY);
        owner2 = _owner2;
    }


    function buyKEEY(uint amount) public {
        require(amount > 0);
        amount2 = amount;
        amount2 = amount2;
        amount1 = amount;
        amount1 = amount1 * rate;
   
        require(msg.sender == owner1, "Only user can buy KEEY");
        // require(msg.sender == owner2, "Only owner2 can buy KEEY");
        // require(msg.sender == owner1 || msg.sender == owner2, "Not authorized");
        // console.log("Allow USDT", USDT.allowance(owner1, address(this)));
        // console.log("Allow KEEY", KEEY.allowance(owner2, address(this)));
        require(
            USDT.allowance(owner1, address(this)) >= amount1,
            "USDT allowance too low!"
        );
        require(
            KEEY.allowance(owner2, address(this)) >= amount2,
            "KEEY not enough to buy!"
        );
        //transfer USDT
        _safeTransferFrom(USDT, owner1, owner2, amount1);
        _safeTransferFrom(KEEY, owner2, owner1, amount2);
    }

    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
}