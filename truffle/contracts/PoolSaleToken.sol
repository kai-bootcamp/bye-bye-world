// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./TokenFactory.sol";
import "./Address.sol";
import "./SafeERC20.sol";
import "./IERC20.sol";
import "./Token.sol";
import "./Context.sol";

/**
 * @dev Smart Contract to handle Tokens Sale.
 */
contract PoolSaleToken is Context {
    using SafeERC20 for IERC20Token;
    // Token sale information
    struct TokenSale {
        address tokenSale;
        address tokenBase;
        uint256 totalSale;
        uint256 totalSold;
        uint256 saleRate;
        uint256 baseRate;
        uint256 maxCap;
        uint256 minCap;
        uint256 tokenId;
        bool isActive;
    }

    // Mapping from token sale ID to owner address
    mapping(uint256 => address) private _owners;

    // List Token sale
    TokenSale[] private _tokenSaleInfos;

    // TokenSale length
    uint256 private _tokenSaleLength;

    /**
     * @dev create new TokenSale for Pool
     */

    function createTokenSale(
        address tokenSale_,
        address tokenBase_,
        uint256 totalSale_,
        uint256 saleRate_,
        uint256 baseRate_,
        uint256 maxCap_,
        uint256 minCap_
    ) public virtual {
        _tokenSaleInfos.push(
            TokenSale({
                tokenSale: tokenSale_,
                tokenBase: tokenBase_,
                totalSale: totalSale_,
                totalSold: 0,
                saleRate: saleRate_,
                baseRate: baseRate_,
                maxCap: maxCap_,
                minCap: minCap_,
                tokenId: _tokenSaleLength,
                isActive: true
            })
        );
        _owners[_tokenSaleLength] = _msgSender();
        _tokenSaleLength++;
    }

    /**
     *@dev Get list of Token sales
     */
    function tokenSaleInfo() public view virtual returns (TokenSale[] memory) {
        return _tokenSaleInfos;
    }

    /**
     * @dev Get owner of creator token sale
     */

    function getOwnerOfTokenSale(uint256 tokenId)
        public
        view
        virtual
        returns (address)
    {
        return _owners[tokenId];
    }
}
