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

    /**
     * @dev Get TokenSale info of Token Sale Id
     */
    function getTokenSaleOfId(uint256 tokenSaleId)
        public
        view
        virtual
        returns (TokenSale memory)
    {
        return _tokenSaleInfos[tokenSaleId];
    }

    /**
     * @dev send base token to owner of tokensale
     * @dev send sale token to buyer.
     */

    function buySaleToken(uint256 tokenId, uint256 baseAmount) public virtual {
        TokenSale storage tokenSaleStruct = _tokenSaleInfos[tokenId];
        uint256 tokenSaleRequest = (baseAmount * tokenSaleStruct.saleRate) /
            tokenSaleStruct.baseRate;
        uint256 tokenBaseExactly = (tokenSaleRequest *
            tokenSaleStruct.baseRate) / tokenSaleStruct.saleRate;
        IERC20Token saleToken = IERC20Token(tokenSaleStruct.tokenSale);
        IERC20Token baseToken = IERC20Token(tokenSaleStruct.tokenBase);
        address owner = _owners[tokenId];
        require(
            saleToken.allowance(owner, address(this)) >= tokenSaleRequest &&
                (tokenSaleStruct.totalSale - tokenSaleStruct.totalSold) >=
                tokenSaleRequest,
            "Not enough balance token sale for request"
        );
        require(
            tokenBaseExactly >= tokenSaleStruct.minCap &&
                tokenBaseExactly <= tokenSaleStruct.maxCap,
            "Error Limit buy"
        );
        /// sender must be approve baseToken for poolSaleToken before transfer.
        baseToken.safeTransferFrom(_msgSender(), owner, tokenBaseExactly);
        saleToken.safeTransferFrom(owner, _msgSender(), tokenSaleRequest);
        tokenSaleStruct.totalSold += tokenSaleRequest;
    }
}
