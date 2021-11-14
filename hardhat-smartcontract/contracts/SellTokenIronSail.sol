// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract sellKEEYToken {

    using SafeMath for uint;
    uint weigh = 10**4; //Đơn vị tính
    address owner;
    struct TokenSell{
        uint amount;
        uint price;
        bool isActive;
    }
    //map chua thong tin gia token
    mapping(address => mapping(address => TokenSell)) public mapTotalSwapPool;
    constructor(){
        owner = msg.sender;
    }
    function addPool( address _tokenSell, address _tokenPurchase, uint _amount, uint _price) public returns(bool){
        require(msg.sender == owner, "access denied");
          require(ERC20(_tokenSell).balanceOf(msg.sender) >= _amount, "Not enough Token");
        require(ERC20(_tokenSell).allowance(msg.sender,address(this)) >= _amount, "Please approve Smartcontract Sell token");
        TokenSell memory poolSale = TokenSell(_amount,_price,true);
        mapTotalSwapPool[_tokenSell][_tokenPurchase] = poolSale;
        return true;
    }
    function getAmountValid(address _tokenSell) public view returns(uint){
        return( ERC20(_tokenSell).balanceOf(owner) >= ERC20(_tokenSell).allowance(owner, address(this)) ? 
            ERC20(_tokenSell).allowance(owner, address(this)) : ERC20(_tokenSell).balanceOf(owner));
    }
    function getAmountAndPriceOfToken(address _tokenBuy, address _tokenPurchase) public view returns(uint, uint){
        return(getAmountValid(_tokenBuy),mapTotalSwapPool[_tokenBuy][_tokenPurchase].price );
    }
    function caculatePriceOfToken(address _tokenBuy, address _tokenPurchase, uint _amount) public view returns(uint){
        return(caculateMoney(_amount,mapTotalSwapPool[_tokenBuy][_tokenPurchase].price ));
    }
    function checkStatus( address _tokenBuy, address _tokenPurchase, uint _amount) public view returns( bool){
        return (
                getAmountValid(_tokenBuy) >=_amount
                && mapTotalSwapPool[_tokenBuy][_tokenPurchase].isActive);
           
    }
    function buyToken(address _tokenBuy, address _tokenPurchase, uint _amount) public payable returns(uint, uint){
        require(checkStatus(_tokenBuy,_tokenPurchase,_amount), "Invalid token or not enough");
        uint money = caculateMoney(_amount, mapTotalSwapPool[_tokenBuy][_tokenPurchase].price);
        require(ERC20(_tokenPurchase).balanceOf(msg.sender)>= money, "Not enough money to buy token");
        require(ERC20(_tokenPurchase).allowance(msg.sender, address(this)) >= money, "Money approved is not enough");
        purchase(msg.sender, owner,_tokenPurchase,money);
        withDraw(owner,msg.sender,_tokenBuy,_amount);
        return(_amount, money);

    }
    function caculateMoney(uint _numToken, uint _rate) private pure returns (uint){ 
        return _numToken.safeMul(_rate);
    }
    function withDraw(address _send, address _receive, address _token,uint _amount) private{
        ERC20(_token).transferFrom(_send, _receive, _amount);
        
    }
    function purchase( address _pay, address _sell, address _token, uint _amount) private{
        ERC20(_token).transferFrom(_pay, _sell, _amount);
    }

}
library SafeMath {
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
}