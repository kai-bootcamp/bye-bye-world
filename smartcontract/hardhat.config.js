/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

const INFURA_URL =
  "https://rinkeby.infura.io/v3/8805a533b1874818a7e1cfc3aadd3db6";

const USDT_PRIVATE_KEY =
  "1a5075d83018b514c676a0e41d54a372e271f8560558a911194738ae9f520580";

const KEEY_PRIVATE_KEY =
  "4518fb399937f8185f32597f0af341f1af4d524d9482433ee798627110832556";

module.exports = {
  solidity: "0.8.0",
  networks: {
    rinkeby: {
      url: INFURA_URL,
      chainId: 4,
      accounts: [`0x${KEEY_PRIVATE_KEY}`, `0x${USDT_PRIVATE_KEY}`],
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: "XKS6972XEEM3TC1K4QR9P15E2JRS85MANU",
  },
};
