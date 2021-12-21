pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract USDTToken is ERC20 {
    constructor() ERC20("Tether", "USDT") {
        _mint(msg.sender, 1000000000 * 10 ** decimals());
    }
}