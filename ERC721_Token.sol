// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721Receiver {
    function onERC721Received(
        address, address, uint256, bytes memory
    ) external returns (bytes4);
}

contract ERC721Token {
    string private _name;
    string private _symbol;
    
    uint256 private _counter;
    uint256 private _totalSupply;
    
    address private _minter;

    mapping(uint256 => address) private _owners;
    mapping (uint256 => address) private _approved;
    mapping (address => mapping (address => bool)) private _isOperator;
    mapping (uint256 => string) _uris;
    
    uint256[] private _tokens;
    mapping (uint256 => uint256) _index;
    
    mapping (address => uint256[]) _ownedTokens;
    mapping (uint256 => uint256) _indexByOwner;
    
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenID);
    event Approval(address indexed from, address indexed to, uint256 indexed tokenID);
    event ApprovalForAll(address indexed from, address indexed to, bool approved);

    constructor(
        string memory name_,
        string memory symbol_
    ) {
        _name = name_;
        _symbol = symbol_;

        _totalSupply = 0;
        _counter = 0;
        _minter = msg.sender;
    }
    
    function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
        return (
            interfaceID == bytes4(0x01ffc9a7) ||
            interfaceID == bytes4(0x80ac58cd)
        );
    }

    function balanceOf(address account) public view returns (uint256) {
        require(account != address(0), "cannot check balance of address(0)");
        return _ownedTokens[account].length;
    }

    function ownerOf(uint256 tokenID) public view returns (address) {
        address account = _owners[tokenID];
        require(account != address(0), "tokenID does not exist");
        return account;
    }

    function safeTransferFrom(
        address from, address to, uint256 tokenID, bytes memory data
    ) public {
        _checkTransfer(msg.sender, from, to, tokenID);
        _transferFrom(from, to, tokenID);
        if (_isContract(to))
            _checkSafeTransfer(msg.sender, from, to, tokenID, data);
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
    
    function approve(address approved, uint256 tokenID) public {
        require(_isOwnerOrOperator(msg.sender, tokenID), "msg.sender is not authorized");
        _approve(approved, tokenID);
    }
    
    function setApprovalForAll(address operator, bool approved) public {
        require(operator != address(0), "cannot set address(0) as operator");
        _isOperator[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function getApproved(uint256 tokenID) public view returns (address) {
        require(_owners[tokenID] != address(0), "tokenID does not exist");
        return _approved[tokenID];
    }

    function isApprovedForAll(
        address owner, address operator
    ) public view returns (bool) {
        return _isOperator[owner][operator];
    }
    
    function name() public view returns (string memory) {
        return _name;
    }
    
    function symbol() public view returns (string memory) {
        return _symbol;
    }
    
    function tokenURI(uint256 tokenID) public view returns (string memory) {
        require(_owners[tokenID] != address(0), "tokenID does not exist");
        return _uris[tokenID];
    }
    
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    
    function tokenByIndex(uint256 index) public view returns (uint256) {
        require(index < _totalSupply, "token index exceeds total amount");
        return _tokens[index];
    }

    function tokenOfOwnerByIndex(
        address owner, uint256 index
    ) public view returns (uint256) {
        require(index < balanceOf(owner), "token index exceeds amount owned");
        return _ownedTokens[owner][index];
    }
    
    function mint(address to, string memory _tokenURI) public {
        require(msg.sender == _minter, "msg.sender is not authorized");
        require(to != address(0), "cannot mint to address(0)");

        _counter++;
        uint tokenID = _counter;
        _uris[tokenID] = _tokenURI;
        _insertToken(to, tokenID);

        _index[tokenID] = _tokens.length;
        _tokens.push(tokenID);
        _totalSupply = _tokens.length;

        emit Transfer(address(0), to, tokenID);
    }
    
    function burn(uint256 tokenID) public {
        require(_isOwnerOrOperator(msg.sender, tokenID), "msg.sender is not authorized");

        uint256 index = _index[tokenID];
        assert(index < _totalSupply);

        uint256 last = _tokens[_totalSupply - 1];
        _tokens[index] = last;
        _index[last] = index;
        _tokens.pop();
        _totalSupply = _tokens.length;
        
        address owner = ownerOf(tokenID);
        _removeToken(owner, tokenID);
        emit Transfer(owner, address(0), tokenID);
    }

    //----------------------------------------------------
    
    function _checkTransfer(
        address caller, address from, address to, uint256 tokenID
    ) private view returns (bool) {
        require(from != address(0), "cannot transfer from address(0)");
        require(to != address(0), "cannot transfer to address(0)");
        require(from != to, "cannot transfer to the same address");

        require(from == ownerOf(tokenID), "token does not belong to account");
        require(_isOwnerOrOperator(caller, tokenID), "msg.sender is not authorized");

        return true;
    }
    
    function _isOwnerOrOperator(
        address caller, uint256 tokenID
    ) private view returns (bool) {
        address owner = ownerOf(tokenID);
        return (
            caller == owner ||
            caller == getApproved(tokenID) ||
            isApprovedForAll(owner, caller)
        );
    }
    
    function _transferFrom(address from, address to, uint256 tokenID) private {
        _removeToken(from, tokenID);
        _insertToken(to, tokenID);

        _approve(address(0), tokenID);
    }
    
    function _removeToken(address account, uint256 tokenID) private {
        uint256 length = _ownedTokens[account].length;
        uint256 index = _indexByOwner[tokenID];
        assert(index < length);

        uint256 last = _ownedTokens[account][length - 1];
        _ownedTokens[account][index] = last;
        _indexByOwner[last] = index;
        _ownedTokens[account].pop();
        
        _owners[tokenID] = address(0);
    }
    
    function _insertToken(address account, uint256 tokenID) private {
        _indexByOwner[tokenID] = _ownedTokens[account].length;
        _ownedTokens[account].push(tokenID);
        _owners[tokenID] = account;
    }
    
    function _approve(address approved, uint256 tokenID) private {
        _approved[tokenID] = approved;
        emit Approval(ownerOf(tokenID), approved, tokenID);
    }

    function _checkSafeTransfer(
        address operator, address from, address to, uint256 tokenID, bytes memory data
    ) private {
        bytes4 magic = IERC721Receiver(to).onERC721Received(
            operator, from, tokenID, data
        );
        require(magic == bytes4(keccak256(
            "onERC721Received(address,address,uint256,bytes)")
        ), "receiving account does not support ERC721 safe transfer");
    }
    
    function _isContract(address _addr) private view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }    
}