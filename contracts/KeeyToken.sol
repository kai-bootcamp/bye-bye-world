// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract KeeyToken is ERC20 {
    constructor() ERC20("Keey", "KEEY") {
        _mint(msg.sender, 2500 * 10 ** 18);
    }
}