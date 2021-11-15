require("@nomiclabs/hardhat-waffle");

// Go to https://www.alchemyapi.io, sign up, create
// a new App in its dashboard, and replace "KEY" with its key
const ALCHEMY_API_KEY = "vRcdnpikDaQ02o0wc4KoHJ5MiJPwlqQa";

// Replace this private key with your Ropsten account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Be aware of NEVER putting real Ether into testing accounts
const ROPSTEN_KEEY_PRIVATE_KEY = "d86316c9ef10198be8bd4d3b48d536d06a342cc9673c1617d7658e5323f61333";
const ROPSTEN_USDT_PRIVATE_KEY = "90e9818e53842ef24e3438194b4fa36ffe748eed85292a4a64936ebee7fd1e13";

module.exports = {
  solidity: "0.8.1",
  networks: {
    ropsten: {
      url: `https://eth-ropsten.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [`0x${ROPSTEN_KEEY_PRIVATE_KEY}`, `0x${ROPSTEN_USDT_PRIVATE_KEY}`]
    }
  }
};