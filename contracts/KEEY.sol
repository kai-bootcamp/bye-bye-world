// contracts/Box.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract KEEY is ERC20, Ownable, Pausable {
    constructor() ERC20("Iron Sail Token", "KEEY") {
        _mint(msg.sender, 2500 * 10**decimals());
    }

    //overload method decimal to decimal 0
    function decimals() public view virtual override returns (uint8) {
        return 0;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
