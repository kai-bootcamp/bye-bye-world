const { BigNumber } = require("ethers");
const hre = require("hardhat");
const decimal = 1000000000000000000;
async function main() {
  //get Account from config file
  const [keeyOwner, usdtOwner] = await ethers.getSigners();

  console.log("keeyOwner address:", keeyOwner.address);
  console.log("keeyOwner balance:", (await keeyOwner.getBalance()).toString());

  console.log("usdtOwner address:", usdtOwner.address);
  console.log("usdtOwner balance:", (await usdtOwner.getBalance()).toString());

  //for rinkeby test
  const FactoryToken = await hre.ethers.getContractFactory("Token");
  factoryKEEY = await FactoryToken.connect(keeyOwner).deploy(2500, "IronSail", "KEEY");
  console.log("KEEY deployed to:", factoryKEEY.address);

  
  factoryUSDT = await FactoryToken.connect(usdtOwner).deploy(100000000, "Tether", "USDT");
  console.log("USDT deployed to:", factoryUSDT.address);

  const FactoryBuy = await hre.ethers.getContractFactory("SellKEEYToken");
  factoryBuy = await FactoryBuy.connect(keeyOwner).deploy(factoryKEEY.address, factoryUSDT.address, 10000);
  console.log("Buy contract deployed to:", factoryBuy.address);
  
  
  // console.log(await factoryKEEY.connect(keeyOwner).balanceOf(keeyOwner));
  await factoryKEEY.connect(keeyOwner).approve(factoryBuy.address,  2500);
  await factoryBuy.connect(keeyOwner).initFund();
  console.log("init fund successful");
  // for big num
  //await factoryKEEY.connect(keeyOwner).approve(factoryBuy.address, ethers.utils.parseUnits("2500", 18));
  //console.log("KEEY allowance: ", await factoryKEEY.allowance(keeyOwner.address, factoryBuy.address));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
