pragma solidity ^0.8.4;

contract Ownable {
    address private _owner;

    constructor() {
        _owner = msg.sender;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() ==_owner, "Ownable: caller is not the owner");
        _;
    }
}
