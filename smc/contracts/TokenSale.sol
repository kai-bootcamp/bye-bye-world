pragma solidity ^0.8.1;

import "hardhat/console.sol";
import "./Token.sol";
import "./Owned.sol";
import "./SafeMath.sol";

// TODO: use balanceOf instead collectedUsdt

contract TokenSale is Owned {
  using SafeMath for uint256;

  Token public usdtContract;
  Token public keeyContract;
  uint256 public tokenPrice;
  uint256 public remainingToken;
  uint256 public collectedUsdt;

  uint256 public startTimestamp;
  uint256 public endTimestamp;

  event Sell(address buyer, uint256 amount);

  constructor(Token _keeyContract, Token _usdtContract, uint256 _tokenPrice) {
    require(address(_keeyContract) != address(0));
    require(address(_usdtContract) != address(0));

    keeyContract = _keeyContract;
    usdtContract = _usdtContract;
    tokenPrice = _tokenPrice;
    owner = msg.sender;
  }

  function startSale(uint256 _endTimestamp) external onlyOwner {
    endTimestamp = _endTimestamp;

    // Transfer all owner's tokens to TokenSale
    uint256 onwerBalance = keeyContract.balanceOf(msg.sender);
    keeyContract.transferFrom(msg.sender, address(this), onwerBalance);
    remainingToken = onwerBalance;

    startTimestamp = block.timestamp;
    console.log("Start sale at", startTimestamp);

  }

  function buyTokens(uint256 amount) external {
    // Check saling time period
    uint256 currentTime = block.timestamp;
    require(startTimestamp != 0, "Token sale has not started yet");
    require(currentTime <= endTimestamp, "Token sale ended");

    // Check adequate number of remaining tokens
    require(remainingToken >= amount);
  
    // Check allowance User approved for TokenSale
    uint256 totalPrice = amount * tokenPrice;
    uint256 userAllowance = usdtContract.allowance(msg.sender, address(this));
    require(userAllowance >= totalPrice, "You must approve this contract consume enough amount of USDT");

    // Transfer USDT from user to TokenSale
    usdtContract.transferFrom(msg.sender, address(this), totalPrice);
    collectedUsdt += totalPrice;

    // Transfer tokens to user -> reduce remainingToken
    keeyContract.transfer(msg.sender, amount);
    remainingToken -= amount;

    emit Sell(msg.sender, amount);
  }

    /**
     * Endsale function check for passed ending time, transfer collected usdt to owner, and burn remaining tokens
     */
  function endSale() external onlyOwner returns (bool) {
    uint256 currentTime = block.timestamp;
    require(currentTime > endTimestamp, "Sale did not end");

    // Transfer collected usdt to owner
    usdtContract.transfer(owner, collectedUsdt);

    // Burn remaining tokens after sale
    keeyContract.burn(remainingToken);

    console.log("Ended sale at: ", currentTime);

    return true;
  }
}