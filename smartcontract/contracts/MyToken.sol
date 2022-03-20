// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20, Ownable {
    constructor(uint256 _initialSupply, string memory _name, string memory _symbol) ERC20(_name, _symbol){
        _mint(_msgSender(), _initialSupply);
    }
}