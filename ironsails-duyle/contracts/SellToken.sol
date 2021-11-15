// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SellTokenContract is Ownable{
    using SafeERC20 for IERC20;

    // State variables
    address public tokenAddressLAD = 0xb7E13cE03319559EC7bc41C0202E17875b82f222;
    address public tokenAddressUSDT = 0x5074EB29a56b4c2bE687BE27c242BcBb8aA1224c;
    address public LADowner = 0x1D3501C5dfe6D132f94a42b1304c2f1eE9F0871e;
    IERC20 tokenIdo;        // Là đồng bán ra: LAD 
    IERC20 tokenBase;       // Là đồng dùng để mua : USDT
    uint256 rate = 10**10;  // tokenBase / tokenDeposit --> rate = LAD = 10000
    uint256 public totalUSDTDeposited;      // Tổng số lượng token USDT đã được chuyển vào hiện tại
    uint256 public totalLAD;       // Tống số lượng token LAD sẽ được bán ra (trong trường hợp này là bán tất cả = 2500)
    uint256 public totalSupply = 2500;
    uint256 public totalSold;
    mapping(address => uint256) public depositors; // depositors[address người mua] = số USDT người đó đã nạp vào để mua tokenIDO
    
    
    
    constructor() public{
        tokenIdo = IERC20(tokenAddressLAD);
        tokenBase = IERC20(tokenAddressUSDT);
    }
    
    /// Lượng LAD tối thiểu có thể mua: 1
    /// Lượng LAD tối đa có thể mua: 1000
    /// @dev Chỉ cho nạp mua nếu lượng mua vào vẫn còn dưới mức cho phép (individualCap)
    /// @param ammountLAD: Số lượng LAD token muốn mua
    function buy(uint256 ammountLAD) payable public{
        uint256 ammountUSDT = ammountLAD * rate;
        // Kiểm tra xem còn token LAD để bán không
        require(
            (totalSupply - totalSold) > 0 && (totalSupply - totalSold) >= ammountLAD,
            "Sold out!"
        );
        
        // Kiểm tra xem số lượng token nhập mua có nằm trong giới hạn cho phép ko
        require(
            ammountLAD >= 1 && ammountLAD <= 1000,
            "Invalid Number of LAD token!"
        );
        
        // Chuyển tiền USDT từ user --> pool (SeelToken contract)
        tokenBase.safeTransferFrom(msg.sender, address(this), ammountUSDT);

        // Cập nhật pool USDT
        totalUSDTDeposited += ammountUSDT;

        // Lưu lại số lượng USDT của người mua
        // 0.8.0 support check of overloading, so SafeMath is no longer needed
        depositors[msg.sender] += ammountUSDT;
        
        // Chuyển key cho user
        tokenIdo.safeTransferFrom(LADowner, msg.sender, ammountLAD);
        
        // Cập nhật totalSold
        totalSold += ammountLAD;
    }
}