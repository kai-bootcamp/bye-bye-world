pragma solidity ^0.8.0;

contract sellKEEYToken {


    using SafeMath for uint;
    int256 weigh = 10**4; //Đơn vị tính
    mapping(address => mapping(address =>uint)) public mapSwapPool;
    mapping(address => mapping(address => uint)) public mapMin;
    mapping(address => mapping(address => uint)) public mapMax;
    
    function caculateToken(uint numToken, uint rate) public pure returns (uint){
        
        return numToken.safeDiv(rate);
    }
    function swapToken(address tokenFrom, address tokenTo, int number) public {
        //Get address of tokenFrom
        //Get address of tokenTo
        //require();
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