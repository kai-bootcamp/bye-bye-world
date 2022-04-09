//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./utils/Array.sol";

contract PetNFT is ERC721URIStorage{
    using Counters for Counters.Counter;
    using Array for uint256[];
    
    
    Counters.Counter private _tokenIds;
    mapping(address =>  uint256[]) public listTokenIDByOwner;
    
    
    constructor(string memory name, string memory symbol) ERC721(name, symbol){}

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
        if(from != address(0)){
            listTokenIDByOwner[from].removeByValue(tokenId);
        }

        if(to != address(0)){
            listTokenIDByOwner[to].push(tokenId);

        }
    }

    function getTokenByOwner(address user) public view returns(uint256[] memory){
        return listTokenIDByOwner[user];
    }


    function getAllToken() public view returns (uint256[] memory, address[] memory){
        uint tokenLength = _tokenIds.current() - 1;
        uint256[] memory tokenList = new uint256[](tokenLength);
        address[] memory ownerList = new address[](tokenLength);

        for(uint256 i = 0; i < tokenLength; i ++){
            if(address(0) != ownerOf(i + 1)) {
                tokenList[i] = i + 1;
                ownerList[i] = ownerOf(i + 1);
            } 
        }

        return (tokenList, ownerList);
    }


    function mintNFT(address recipient, string memory tokenURI)
      public returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;

    }
}