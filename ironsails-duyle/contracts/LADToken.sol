// SPDX-License-Identifier: NONE
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LADToken is ERC20, Ownable{
    
    // / @dev SafeMath is a solidity math library especially designed to support safe math operations: safe means that it prevents overflow when working with uint.
    using SafeMath for uint;

    /// @dev Tổng số lượng token sẽ tung ra bán
    uint256 private totalTokens;

    
    /// @dev Gọi hàm constructor của base contract ERC20(tên token, symbol token)
    constructor() ERC20("Ironsail - Le Anh Duy", "LAD") {
        // Xác định tổng cung
        totalTokens = 2500;
        // Mint toàn bộ tổng cung token và gửi cho contract owner
        _mint(owner(), totalTokens);
    }

    /// @dev decimals = 0 --> Giá trị hiển thị cho user chính là giá trị balanceOf
    function decimals() public view virtual override returns (uint8) {
        return 0;
    }
}