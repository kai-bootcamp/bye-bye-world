// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Owned {
  address public owner;

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
  //transfer contract to another account
  function transferOwnership(address newOwner) public onlyOwner {
    owner = newOwner;
  }
}