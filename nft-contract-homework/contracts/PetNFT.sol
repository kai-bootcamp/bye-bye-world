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
    mapping(address =>  uint256[]) listTokenIDByOwner;
    
    
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