// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Crowdsale.sol";

// import "./AllowanceCrowdsale.sol";
// import "./TimedCrowdsale.sol";

contract KeeyTokenCrowdsale is Crowdsale {
    using SafeERC20 for IERC20;
    IERC20 private usdt;

    constructor(
        uint256 _rate,
        address payable _wallet,
        ERC20 _token,
        IERC20 _usdtToken
    ) Crowdsale(_rate, _wallet, _token) {
        usdt = _usdtToken;
    }

    /**
     * @dev Extend parent behavior requiring to be within contributing period.
     * @param beneficiary Token purchaser
     * @param weiAmount Amount of wei contributed
     */
    function _preValidatePurchase(address beneficiary, uint256 weiAmount)
        internal
        view
        override(Crowdsale)
    {
        super._preValidatePurchase(beneficiary, weiAmount);
    }

    /**
     * @dev Overrides parent behavior by transferring tokens from wallet.
     * @param beneficiary Token purchaser
     * @param tokenAmount Amount of tokens purchased
     */
    function _deliverTokens(address beneficiary, uint256 tokenAmount)
        internal
        override(Crowdsale)
    {
        //require(_usdt.allowance(msg.sender, address(_usdt))>=10*10**6,"Invalid USDT Allowance");
        //msg.sender.approve(address(token()), msg.value);
        usdt.safeTransferFrom(msg.sender,address(this), msg.value); //loc
        super._deliverTokens(beneficiary, tokenAmount);
    }
}
