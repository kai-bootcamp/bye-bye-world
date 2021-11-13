// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.1;

import "hardhat/console.sol";
import "./Owned.sol";


// This is the main building block for smart contracts.
contract Token is Owned {
    // Some string type variables to identify the token.
    // The `public` modifier makes a variable readable from outside the contract.
    string public name;
    string public symbol;

    // The fixed amount of tokens stored in an unsigned integer type variable.
    uint256 public totalSupply;

    // A mapping is a key/value map. Here we store each account balance.
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) public allowance;

    /**
     * Contract initialization.
     *
     * The `constructor` is executed only once when the contract is created.
     */
    constructor(uint256 _totalSupply, string memory _name, string memory _symbol) {
        // The totalSupply is assigned to transaction sender, which is the account
        // that is deploying the contract.
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply;
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    /**
     * A function to transfer tokens.
     *
     * The `external` modifier makes a function *only* callable from outside
     * the contract.
     */
    event Transfer(address from, address to, uint256 amount);
    function transfer(address to, uint256 amount) external {
        console.log("Sender balance is %s tokens", balances[msg.sender]);
        console.log("Trying to send %s tokens to %s", amount, to);

        // Check if the transaction sender has enough tokens.
        // If `require`'s first argument evaluates to `false` then the
        // transaction will revert.
        require(balances[msg.sender] >= amount, "Not enough tokens");

        // Transfer the amount.
        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
    }


    event Approval(address owner, address spender, uint256 amount);
    function approve(address spender, uint amount) external returns (bool success) {
        require(allowance[msg.sender][spender] == 0, "Current allowance is different from zero");
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }


    /**
     * A function to transfer tokens from owner.
    */
    function transferFrom(address from, address to, uint256 amount) external {
        console.log("Allowance is %s tokens", allowance[from][msg.sender]);
        console.log("Sender balance is %s tokens", balances[from]);
        console.log("Trying to send %s tokens to %s", amount, to);

        // Check if the transaction sender has enough tokens.
        require(balances[from] >= amount, "Not enough tokens");

        // Check if the transaction sender has enough allowance tokens.
        require(allowance[from][msg.sender] >= amount, "Not enough allowance");

        // Transfer the amount.
        balances[from] -= amount;
        allowance[from][msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    /**
     * Read only function to retrieve the token balance of a given account.
     *
     * The `view` modifier indicates that it doesn't modify the contract's
     * state, which allows us to call it without executing a transaction.
     */
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }


    event TotalSupplyChange(uint256 remainingTotalSupply);
    /**
     * A function to burn the tokens belong to sender.
     */
    function burn(uint256 amount) external  {
        require(balances[msg.sender] >= amount, "Not enough token to burn");

        balances[msg.sender] -= amount;
        totalSupply -= amount;

        emit TotalSupplyChange(totalSupply);
    }
}