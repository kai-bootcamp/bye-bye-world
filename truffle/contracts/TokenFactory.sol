/// SPDX-License-Identifier: MIT
/**
 *@dev From version 0.8.0 solidity Integrated SafeMath
 */
pragma solidity ^0.8.10;

import "./IERC20.sol";
import "./Token.sol";
import "./Context.sol";

/**
 * @dev Contract handle create a new Token.
 */

contract TokenFactory is Context {
    // Mapping from creator to token address.
    mapping(address => address) private _tokens;

    // Mapping from token to url.
    mapping(address => string) private _urls;

    /**
     * @dev Return token address latest of creator.
     */
    function tokenOf(address creator) public view virtual returns (address) {
        return _tokens[creator];
    }

    function tokenUrl(address token)
        public
        view
        virtual
        returns (string memory)
    {
        return _urls[token];
    }

    /**
     *@dev Create New Token.
     */
    function create(
        address poolSaleToken,
        string memory name_,
        string memory symbol_,
        string memory url_,
        uint8 decimal_,
        uint256 totalSupply_
    ) public virtual returns (address) {
        Token newToken = new Token(
            msg.sender,
            poolSaleToken,
            name_,
            symbol_,
            decimal_,
            totalSupply_
        );
        address addressNewToken = address(newToken);
        _tokens[msg.sender] = addressNewToken;
        _urls[addressNewToken] = url_;
        return addressNewToken;
    }

    /**
     * @dev Return all information of token
     */

    function informationOfToken(address token)
        public
        view
        virtual
        returns (
            string memory name_,
            string memory symbol_,
            uint8 decimal_,
            uint256 totalSupply_,
            string memory url_
        )
    {
        IERC20Token tokenContract = IERC20Token(token);
        name_ = tokenContract.name();
        symbol_ = tokenContract.symbol();
        decimal_ = tokenContract.decimals();
        totalSupply_ = tokenContract.totalSupply();
        url_ = _urls[token];
    }
}
