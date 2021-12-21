pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SellKEEYToken {
    uint16 constant private _rate = 10000;

    // All these addresses are deployed on Ropsten testnet
    address constant USDT_ADDRESS = 0xdb113b28Fd4E7E772F56cfE938AebA165BD2C47A;
    address constant KEEY_ADDRESS = 0x20DF1Ac97c5f6d9236f2Cfd1D185bF6ef86B8FAB;
    address constant WALLET = 0x157a13F043E596759278Ba916020A353c40C02Af;

    function buyKEEYToken(uint16 number) public payable {
        IERC20 usdtToken = IERC20(USDT_ADDRESS);
        IERC20 keeyToken = IERC20(KEEY_ADDRESS);

        keeyToken.transferFrom(WALLET, msg.sender, number);
        usdtToken.transferFrom(msg.sender, WALLET, number * _rate);
    }
}