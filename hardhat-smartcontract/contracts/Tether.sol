// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <0.9.0;

import "./IERC20.sol";
import "./Owned.sol";
contract Tether is IERC20, Owned {

    string public constant name = "Tether";
    string public constant symbol = "USDT";
    uint8 public constant decimals = 18;
    uint256 totalSupply_ = 10000000000;

    // Table to map addresses to their balance
    mapping(address => uint256) balances;
    // Mapping owner address to
    // those who are allowed to
    // use the contract
    mapping(address => mapping (address => uint256)) allowed;

    using SafeMath for uint256;

   constructor() {
        totalSupply_ = 10000000000 * 10 ** 18;
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public override view returns (uint256) {
    return totalSupply_;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        // transfers the value if
        // balance of sender is
        // greater than the amount
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        // Fire a transfer event for
        // any logic that is listening
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }


    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        // If the address is allowed
        // to spend from this contract
        allowed[msg.sender][delegate] = numTokens;
        // Fire the event "Approval"
        // to execute any logic that
        // was listening to it
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    /* The transferFrom method is used for
    a withdraw workflow, allowing
    contracts to send tokens on
    your behalf, for example to
    "deposit" to a contract address
    and/or to charge fees in sub-currencies;*/

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        // Fire a Transfer event for
        // any logic that is listening
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
}
