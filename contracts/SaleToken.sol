pragma solidity ^0.8.0;

import "./ERC20.sol";
import "./Ownable.sol";
import "./SafeMath.sol";
import "./Token.sol";

contract SellToken {

    using SafeMath for uint256;

    Token tokenKEEY;       
    Token tokenUSDT;       
    uint256 rate = 10**10; 
    uint256 public receivedUSDT;    
    uint256 public availableKEEY;
    uint256 public KEEY;
    address public adminWallet = 0x1D3501C5dfe6D132f94a42b1304c2f1eE9F0871e; 
    mapping(address => uint256) public userWallet; 


    function buy(uint256 amount) public {

        // ERC20.totalSupply();
        uint256 transferAmount = amount * rate;

        require(availableKEEY > 0, "Sold out!");
        require(availableKEEY > 0, "Sold out!");
        
        // // Kiểm tra xem số lượng token nhập mua có nằm trong giới hạn cho phép ko
        // require(
        //     ammountLAD >= 1 && ammountLAD <= 1000,
        //     "Invalid Number of LAD token!"
        // );
        
        // // Chuyển tiền USDT vào ví poolWallet
        // tokenBase.transfer(poolWallet, ammountUSDT);

        // // Cập nhật pool USDT
        // totalUSDTDeposited += ammountUSDT;

        // // Lưu lại số lượng USDT của người mua
        // // 0.8.0 support check of overloading, so SafeMath is no longer needed
        // depositors[msg.sender] += ammountUSDT;
        
        // // Chuyển key cho user
        // tokenIdo.transfer(msg.sender, ammountLAD);
        
        // // Cập nhật totalSold
        // totalSold += ammountLAD;
    }
}
