// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  // provider = ethers.provider;
  console.log("Account balance:", (await deployer.getBalance()).toString());
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Keey = await hre.ethers.getContractFactory("KEEY");
  const KeeyToken = await Keey.deploy();
  // const KeeyDeployed = await KeeyToken.deployed();
  console.log("KeeyToken deployed to:", KeeyToken.address);
  const Tether = await hre.ethers.getContractFactory("Tether");
  const TetherToken = await Tether.deploy();
  // const TetherDeployed = await TetherToken.deployed();

  console.log("TetherToken deployed to:", TetherToken.address);
  const ICO = await hre.ethers.getContractFactory("KeeyTokenCrowdsale");
  const ICOToken = await ICO.deploy(
    10,
    "0x15d34aaf54267db7d7c367839aaf71a00a2c6a65",
    KeeyToken.address,
    TetherToken.address
  );
  console.log("ICOToken deployed to:", ICOToken.address);
  // const ICODeployed = await ICOToken.deployed();
  await KeeyToken.transfer(ICOToken.address, KeeyToken.totalSupply());
  // console.log("After Transfer:", await provider .getBalance(ICOToken.address).toString());
  console.log(
    "After Transfer ICO Contract Have :",
    (await KeeyToken.balanceOf(ICOToken.address)).toString()
  );

  await TetherToken.transfer(
    "0x2546bcd3c84621e976d8185a91a922ae77ecec30",
    10000 * 10 ** 6
  );
  // console.log("After Transfer:", await provider .getBalance(ICOToken.address).toString());
  console.log(
    "After Transfer USDT account Have :",
    (
      await TetherToken.balanceOf("0x2546bcd3c84621e976d8185a91a922ae77ecec30")
    ).toString()
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
