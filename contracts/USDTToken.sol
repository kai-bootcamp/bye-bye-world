// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";

contract USDTToken is ERC20 {
    constructor() ERC20("Dollar", "USDT") {
        _mint(msg.sender, 1000000000 * 10 ** 18);
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        console.log("From: %s, To: %s", from, to);
        // address spender = _msgSender();
        _spendAllowance(from, to, amount);
        _transfer(from, to, amount);
        return true;
    }
}