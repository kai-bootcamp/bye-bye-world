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
module.exports = {
  defaultNetwork: "hardhat",
  paths: {
    artifacts: './src/artifacts',
  },
  networks: {
    hardhat: {},
    rinkeby: {
      // Lấy url từ infura và paste vào đây
      url: "https://rinkeby.infura.io/v3/6d2497e7d52f46e9a96eed12ba578a3c",
      accounts: ["dbda1821b80551c9d65939329250298aa3472ba22feea921c0cf5d620ea67b97"]
    }
  },
  solidity: "0.8.4",
};
