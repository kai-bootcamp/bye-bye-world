// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";

import "./ERC20.sol";
import "./Ownable.sol";
import "./SafeMath.sol";

contract Token is Ownable{

    mapping (address => uint256) public balance;
    // address public owner;// = "IronSailToken";
    string public name;// = "IronSailToken";
    string public symbol;//= "KEEY";
    uint8 public decimals ;//= 0;
    uint256 public _totalSupply;// = 2500 * (uint256(10) ** decimals);
    
    constructor() {
        // The totalSupply is assigned to transaction sender, which is the account
        // that is deploying the contract.
        name = "IronSailToken";
        symbol =  "KEEY";
        _totalSupply = 2500 * (uint256(10) ** decimals);
        balance[msg.sender] = _totalSupply;
        // owner = msg.sender;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    function CreateERC20Token() public {
        balance[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
}

