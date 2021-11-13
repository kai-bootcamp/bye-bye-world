/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 *@dev expands information of Token.
 */

interface TokenMetadata {
    function tokenUrl() external view returns (string memory);

    function creator() external view returns (address);

    function information()
        external
        view
        returns (
            string memory name_,
            string memory symbol_,
            uint8 decimal_,
            uint256 totalSupply_,
            string memory url_
        );
}
