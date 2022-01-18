// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <0.9.0;

import "./Owned.sol";
import "./SafeMath.sol";
// interface IERC20 {

//     function totalSupply() external view returns (uint256);
//     function balanceOf(address account) external view returns (uint256);
//     function allowance(address owner, address spender) external view returns (uint256);

//     function transfer(address recipient, uint256 amount) external returns (bool);
//     function approve(address spender, uint256 amount) external returns (bool);
//     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


//     event Transfer(address indexed from, address indexed to, uint256 value);
//     event Approval(address indexed owner, address indexed spender, uint256 value);
// }
contract Token is Owned{
    string public name;
    string public symbol;
    // uint8 decimals = 18;
    uint256 totalSupply_;

    // Table to map addresses to their balance
    mapping(address => uint256) balances;
    // Mapping owner address to
    // those who are allowed to
    // use the contract
    mapping(address => mapping (address => uint256)) allowed;

    using SafeMath for uint256;

    constructor(uint256 _totalSupply, string memory _name, string memory _symbol) {
        totalSupply_ = _totalSupply;
        name = _name;
        symbol = _symbol;
        // decimals = 18;
        balances[msg.sender] = totalSupply_;
        owner = msg.sender;
    }

    function totalSupply() public  view returns (uint256) {
    return totalSupply_;
    }

    function balanceOf(address tokenOwner) public  view returns (uint256) {
        return balances[tokenOwner];
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    function transfer(address receiver, uint256 numTokens) public  returns (bool) {
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

    event Approval(address indexed owner, address indexed spender, uint256 value);
    function approve(address delegate, uint256 numTokens) public  returns (bool) {
        // If the address is allowed
        // to spend from this contract
        allowed[msg.sender][delegate] = numTokens;
        // Fire the event "Approval"
        // to execute any logic that
        // was listening to it
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public  view returns (uint256) {
        return allowed[owner][delegate];
    }

    /* The transferFrom method is used for
    a withdraw workflow, allowing
    contracts to send tokens on
    your behalf, for example to
    "deposit" to a contract address
    and/or to charge fees in sub-currencies;*/

    function transferFrom(address owner, address buyer, uint256 numTokens) public  returns (bool) {
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
