// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract KEEYToken is ERC20, Ownable {

    constructor() ERC20('KEEYToken', 'KEEY') {
        _mint(owner(), 2500);
    }
}