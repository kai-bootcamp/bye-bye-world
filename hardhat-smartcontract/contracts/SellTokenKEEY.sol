pragma solidity ^0.8.0;
//Doi lai thanh https khi deploy
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract sellKEEYToken {

  
    using SafeMath for uint;
    int256 weigh = 10**4; //Đơn vị tính
    struct tokenSellInfo { 
      address seller;
      uint totalAmount;
      uint amountValid;
      uint soldAmount; 
      uint price;
      uint min;
      uint max;
      uint start;
      uint daysAfter; 
      bool isActive;
   }
    //Map chứa thông tin đăng ký bán token
    mapping(address => mapping(address => tokenSellInfo)) public mapTotalSwapPool;
    
    function caculateMoney(uint _numToken, uint _rate) private pure returns (uint){ 
        return _numToken.safeMul(_rate);
    }

    function registerSellToken(address _tokenSell,address _tokenReceiver, uint _amount,uint _price, uint _daysAfter) public returns (bool){
        //Kiem tra da dang ky cap token nay truoc do chua
        require(_amount > 0 && _daysAfter > 0 && _price >=0, "Amount token, price and number day sell must more than 0" );
        require(ERC20(_tokenSell).balanceOf(msg.sender) >= _amount, "Not enough money" );
        require(ERC20(_tokenSell).allowance(msg.sender, address(this)) >= _amount, "Please approve amount token as register" );
        /** 
            Default min = 1 va max = 5
         */
        tokenSellInfo memory _tokenSellInfo = tokenSellInfo( msg.sender,_amount,_amount,0,_price,1,5,block.timestamp, _daysAfter, true);
        mapTotalSwapPool[_tokenSell][_tokenReceiver] = _tokenSellInfo;
        return true;
    }

    function getValidToken(address _tokenBuy, address _tokenPurchase) private view returns(uint){
        uint tokenSMValid = mapTotalSwapPool[_tokenBuy][_tokenPurchase].amountValid;
        uint tokenOfSeller = ERC20(_tokenBuy).balanceOf(mapTotalSwapPool[_tokenBuy][_tokenPurchase].seller);
        uint token_Avaiable = tokenSMValid >= tokenOfSeller ? tokenOfSeller :tokenSMValid;
        return( token_Avaiable);
    }

    function checkStatus( address _tokenBuy, address _tokenPurchase, uint _amount) public view returns( bool){

        return (
                getValidToken(_tokenBuy,_tokenPurchase) >=_amount
                && mapTotalSwapPool[_tokenBuy][_tokenPurchase].isActive 
                && mapTotalSwapPool[_tokenBuy][_tokenPurchase].amountValid >= _amount
                && mapTotalSwapPool[_tokenBuy][_tokenPurchase].start + 
                mapTotalSwapPool[_tokenBuy][_tokenPurchase].daysAfter* 1 days >= block.timestamp);
           
    }
    function getTokenPoolInfo(address _tokenBuy, address _tokenPurchase) public view returns(uint avaiable, uint price, uint min, uint max){
        
        return( getValidToken(_tokenBuy,_tokenPurchase),
                mapTotalSwapPool[_tokenBuy][_tokenPurchase].price,
                mapTotalSwapPool[_tokenBuy][_tokenPurchase].min,
                mapTotalSwapPool[_tokenBuy][_tokenPurchase].max);
    }
    function cancelSellToken(address _tokenSell,address _tokenReceiver) public returns(bool){
        require(mapTotalSwapPool[_tokenSell][_tokenReceiver].seller == msg.sender, "Not found" );
        mapTotalSwapPool[_tokenSell][_tokenReceiver].isActive = false;
        return true;
    }
    //function bán token 
    //function purchase về cho người bán
    //function withraw trả token cho người mua
    function buyToken (address _tokenBuy, address _tokenPurchase, uint _amount) public returns (bool){
        require(_amount >0 , "Amount invalid");
        require(checkStatus(_tokenBuy,_tokenPurchase,_amount), "Can not buy token");
        uint money = caculateMoney(_amount,mapTotalSwapPool[_tokenBuy][_tokenPurchase].price);
        require(ERC20(_tokenPurchase).balanceOf(msg.sender)>= money, "Not enough money to buy token");
        require(ERC20(_tokenPurchase).allowance(msg.sender, address(this)) >= money, "Money approved is not enough");
        purchase(msg.sender,mapTotalSwapPool[_tokenBuy][_tokenPurchase].seller,_tokenPurchase, money);
        withDraw(mapTotalSwapPool[_tokenBuy][_tokenPurchase].seller,msg.sender,_tokenBuy,_amount);
        mapTotalSwapPool[_tokenBuy][_tokenPurchase].amountValid -= _amount;
        mapTotalSwapPool[_tokenBuy][_tokenPurchase].soldAmount += _amount;
        return true;
    }
    function withDraw(address _send, address _receive, address _token,uint _amount) private{
        ERC20(_token).transferFrom(_send, _receive, _amount);
        
    }
    function purchase( address _pay, address _sell, address _token, uint _amount) private{
        ERC20(_token).transferFrom(_pay, _sell, _amount);
    }
    
}
library SafeMath {
     function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }

    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}