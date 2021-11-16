//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol";

contract FishCrowed is Ownable{
    using SafeERC20 for IERC20;

    // State variables
    address public fishAddress ;
    address public usdtAddress ;
    address public fishAddressBase ;
    IERC20 tokenFish;
    IERC20 tokenUSD;
    uint256 rate = 10**10;
    uint256 public totalUSD;
    uint256 public totalFish;
    uint256 public totalSupply = 2500;
    uint256 public totalSell;
    mapping(address => uint256) public deposit;



    constructor() public{
        tokenFish = IERC20(fishAddress);
        tokenUSD = IERC20(usdtAddress);
    }


    function buy(uint256 amount) payable public{
        uint256 value = amount * rate;

        require(
            (totalSupply - totalSell) > 0 && (totalSupply - totalSell) >= amount,
            "Go to the moon!"
        );


        require(
            amount >= 1 && amount <= 1000,
            "Invalid !"
        );


        tokenUSD.safeTransferFrom(msg.sender, address(this), value);


        totalUSD += value;


        deposit[msg.sender] += value;


        tokenFish.safeTransferFrom(fishAddressBase, msg.sender, value);


        totalSell += value;
    }
}