// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721Receiver {
    function onERC721Received(
        address, address, uint256, bytes memory
    ) external returns (bytes4);
}

contract ERC721Token {
    string private _name;
    function name() public view returns (string memory) {
        return _name;
    }
    string private _symbol;
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    constructor(
        string memory name_,
        string memory symbol_
    ) {
        _name = name_;
        _symbol = symbol_;

        _totalSupply = 0;
        _minter = msg.sender;
    }

    function balanceOf(address account) public view returns (uint256) {
        require(account != address(0));
        return _ownedTokens[account].length;
    }

    mapping(uint256 => address) private _owners;
    function ownerOf(uint256 tokenID) public view returns (address) {
        address account = _owners[tokenID];
        require(account != address(0));
        return account;
    }

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenID);
    function isContract(address _addr) private view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }
    function checkSafeTransfer(
        address operator, address from, address to, uint256 tokenID, bytes memory data
    ) private {
        bytes4 magic = IERC721Receiver(to).onERC721Received(
            operator, from, tokenID, data
        );
        require(magic == bytes4(keccak256(
            "onERC721Received(address,address,uint256,bytes)")
        ));
    }
    function safeTransferFrom(
        address from, address to, uint256 tokenID, bytes memory data
    ) public {
        _checkTransfer(msg.sender, from, to, tokenID);
        _transferFrom(from, to, tokenID);
        if (isContract(to))
            checkSafeTransfer(msg.sender, from, to, tokenID, data);
        emit Transfer(from, to, tokenID);
    }

    function safeTransferFrom(address from, address to, uint256 tokenID) public {
        safeTransferFrom(from, to, tokenID, "");
    }

    function transferFrom(address from, address to, uint256 tokenID) public {
        _checkTransfer(msg.sender, from, to, tokenID);
        _transferFrom(from, to, tokenID);

        emit Transfer(from, to, tokenID);
    }

    function _checkTransfer(
        address caller, address from, address to, uint256 tokenID
    ) private view returns (bool) {
        require(from != address(0), "invalid <from> address");
        require(to != address(0), "invalid <to> address");
        require(from != to, "can't transfer to yourself");

        require(from == ownerOf(tokenID), "<tokenID> does not belong to <from>");
        require(
            caller == from ||
            caller == getApproved(tokenID) ||
            isApprovedForAll(from, caller),
            "msg.sender is not authorized"
        );

        return true;
    }

    function _removeToken(address account, uint256 tokenID) private {
        uint256 length = balanceOf(account);
        uint256 index = _indexOfToken[tokenID];
        assert(index < length);

        _ownedTokens[account][index] = _ownedTokens[account][length - 1];
        _ownedTokens[account].pop();
    }
    function _insertToken(address account, uint256 tokenID) private {
        _indexOfToken[tokenID] = balanceOf(account);
        _ownedTokens[account].push(tokenID);
        _owners[tokenID] = account;
    }
    function _transferFrom(address from, address to, uint256 tokenID) private {
        _removeToken(from, tokenID);
        _insertToken(to, tokenID);

        _approve(address(0), tokenID);
    }

    mapping (uint256 => address) _approved;
    event Approval(address indexed from, address indexed to, uint256 indexed tokenID);
    function _checkApproval(address caller, address owner) private view returns (bool) {
        require(
            owner == caller ||
            isApprovedForAll(owner, caller)
        );
        return true;
    }
    function _approve(address approved, uint256 tokenID) private {
        _approved[tokenID] = approved;
        emit Approval(ownerOf(tokenID), approved, tokenID);
    }
    function approve(address approved, uint256 tokenID) public {
        address owner = ownerOf(tokenID);
        _checkApproval(msg.sender, owner);
        _approve(approved, tokenID);
    }

    mapping (address => mapping (address => bool)) _isOperator;
    event ApprovalForAll(address indexed from, address indexed to, bool approved);
    function setApprovalForAll(address operator, bool approved) public {
        require(operator != address(0));
        _isOperator[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function getApproved(uint256 tokenID) public view returns (address) {
        require(ownerOf(tokenID) != address(0));
        return _approved[tokenID];
    }

    function isApprovedForAll(
        address owner, address operator
    ) public view returns (bool) {
        return _isOperator[owner][operator];
    }

    function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
        return (
            interfaceID == bytes4(0x01ffc9a7) ||
            interfaceID == bytes4(0x80ac58cd)
        );
    }

    mapping (uint256 => string) _uris;
    function _exists(uint256 tokenID) private view returns (bool) {
        return (_owners[tokenID] != address(0));
    }
    function tokenURI(uint256 tokenID) public view returns (string memory) {
        require(_exists(tokenID));
        return _uris[tokenID];
    }

    address private _minter;
    function mint(address to, string memory _tokenURI) public {
        require(msg.sender == _minter);
        require(to != address(0));

        _totalSupply++;
        uint tokenID = _totalSupply;
        _uris[tokenID] = _tokenURI;
        _insertToken(to, tokenID);

        emit Transfer(address(0), to, tokenID);
    }

    uint256 private _totalSupply;
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function tokenByIndex(uint256 index) public view returns (uint256) {
        require(index < _totalSupply);
        return index + 1;
    }

    mapping (address => uint256[]) _ownedTokens;
    mapping (uint256 => uint256) _indexOfToken;
    function tokenOfOwnerByIndex(
        address owner, uint256 index
    ) public view returns (uint256) {
        require(index < balanceOf(owner));
        return _ownedTokens[owner][index];
    }
}