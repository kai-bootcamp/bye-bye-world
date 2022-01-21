require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */

// Go to https://www.alchemyapi.io, sign up, create
// a new App in its dashboard, and replace "KEY" with its key
const ALCHEMY_API_KEY = "fb312f63580548ecbf50f252c57cf544";

// Replace this private key with your Rinkeby account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Be aware of NEVER putting real Ether into testing accounts
const RINKEBY_PRIVATE_KEY_USDT = "a2b1f4793c9bfc257765d279597637d3f21545929126d4e036298942a19361d1";
// const RINKEBY_PRIVATE_KEY_KEEY = "ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";
const RINKEBY_PRIVATE_KEY_KEEY = "be2b5ad7c6e19d9a6059e6e7bca3d043a9933a533426358535d7c2125bf366d7";
module.exports = {
  solidity: "0.8.4",
  paths: {
    sources: "./contracts",
    tests: "./test/",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  networks: {
    hardhat: {
      chainId: 1337
    },
    rinkeby: {
      // Lấy url từ infura và paste vào đây
      url: `https://rinkeby.infura.io/v3/${ALCHEMY_API_KEY}`,
      accounts: [`${RINKEBY_PRIVATE_KEY_USDT}`, `${RINKEBY_PRIVATE_KEY_KEEY}`],
      gas: 2100000,
      gasPrice: 8000000000
    }
  },
};
