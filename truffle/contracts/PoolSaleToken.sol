// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./TokenFactory.sol";
import "./Ownable.sol";

/**
 * @dev Smart Contract to handle Tokens Sale.
 */
contract PoolSaleToken is Ownable {
    // Token sale information
    struct TokenSale {
        Token tokenSale;
        IERC20 tokenBase;
        uint256 totalSale;
        uint256 totalSold;
        uint256 startTime;
        uint256 endTime;
        uint256 saleRate;
        uint256 baseRate;
        uint256 maxCap;
        uint256 minCap;
        address owner;
    }

    // Mapping from token sale ID to owner address
    mapping(uint256 => address) private _owners;

    // List Token sale
    TokenSale[] public tokenSaleInfos;

    function createTokenSale(
        address tokenSale_,
        address tokenBase_,
        uint256 totalSale_,
        uint256 totalSold_,
        uint256 startTime_,
        uint256 endTime_,
        uint256 saleRate_,
        uint256 baseRate_,
        uint256 maxCap_,
        uint256 minCap_
    ) public virtual {
        tokenSaleInfos.push(
            TokenSale({
                tokenSale: Token(tokenSale_),
                tokenBase: IERC20(tokenBase_),
                totalSale: totalSale_,
                totalSold: totalSold_,
                startTime: startTime_,
                endTime: endTime_,
                saleRate: saleRate_,
                baseRate: baseRate_,
                maxCap: maxCap_,
                minCap: minCap_,
                owner: msg.sender
            })
        );
    }
}
