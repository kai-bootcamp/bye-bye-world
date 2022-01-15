const hre = require("hardhat");
const decimal = 1000000000000000000;
async function main() {
  //get Account from config file
  const [keeyOwner, usdtOwner] = await ethers.getSigners();

  console.log("keeyOwner address:", keeyOwner.address);
  console.log("keeyOwner balance:", (await keeyOwner.getBalance()).toString());

  console.log("usdtOwner address:", usdtOwner.address);
  console.log("usdtOwner balance:", (await usdtOwner.getBalance()).toString());

  
  // console.log("testOwner address:", testOwner.address);
  // console.log("testtOwner balance:", (await testOwner.getBalance()).toString());

  //for localhost test
  // const KEEYToken = await hre.ethers.getContractFactory("KEEYToken");
  // const deployKEEYToken = await KEEYToken.deploy();

  // await deployKEEYToken.deployed();
  // console.log("KEEY deployed to:", deployKEEYToken.address);

  //for rinkeby test
  const FactoryKEEY = await hre.ethers.getContractFactory("KEEYToken");
  factoryKEEY = await FactoryKEEY.connect(keeyOwner).deploy();
  console.log("KEEY deployed to:", factoryKEEY.address);

  const FactoryUSDT = await hre.ethers.getContractFactory("Tether");
  factoryUSDT = await FactoryUSDT.connect(usdtOwner).deploy();
  console.log("USDT deployed to:", factoryUSDT.address);

  const FactoryBuy = await hre.ethers.getContractFactory("TokenSwap");
  factoryBuy = await FactoryBuy.connect(usdtOwner).deploy(factoryUSDT.address, usdtOwner.address, factoryKEEY.address, keeyOwner.address);
  console.log("Buy contract deployed to:", factoryBuy.address);
  
  await  factoryKEEY.connect(keeyOwner).approve(factoryBuy.address, ethers.utils.parseUnits("2500", 18));
  await  factoryUSDT.connect(usdtOwner).approve(factoryBuy.address, ethers.utils.parseUnits("10000000000", 18));
  console.log("USDT allowance: ", await factoryUSDT.allowance(usdtOwner.address, factoryBuy.address));
  //console.log("Test approve: ", await factoryKEEY.connect(keeyOwner).approve(factoryBuy.address, 2500));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
