const fs = require("fs");
const { ethers } = require("hardhat");

async function main() {
  const [keeyOwner, usdtOwner] = await ethers.getSigners();
  console.log(`Deploying contracts with the account of KEEY Owner: ${keeyOwner.address}
  and USDT Owner: ${usdtOwner.address}`);

  console.log(
    `KEEY Owner balance: ${(await keeyOwner.getBalance()).toString()}`
  );
  console.log(
    `USDT Owner balance: ${(await usdtOwner.getBalance()).toString()}`
  );

  const Token = await ethers.getContractFactory("Token");
  const factoryKEEY = await Token.connect(keeyOwner).deploy(
    ethers.utils.parseEther("2500"),
    "Keey",
    "KEEY"
  );
  const factoryUSDT = await Token.connect(usdtOwner).deploy(
    ethers.utils.parseEther("100000000"),
    "Tether",
    "USDT"
  );

  console.log(`Keey address: ${factoryKEEY.address}`);
  console.log(`USDT address: ${factoryUSDT.address}`);

  const BuyContract = await ethers.getContractFactory("sellMyToken");
  const factoryBuyContract = await BuyContract.connect(keeyOwner).deploy(
    factoryKEEY.address,
    factoryUSDT.address,
    "10000"
  );

  console.log("Buy Contract address:", factoryBuyContract.address);

  const data = {
    KEEYaddress: factoryKEEY.address,
    USDTaddress: factoryUSDT.address,
    sellMyTokenaddress: factoryBuyContract.address,
    KEEYabi: JSON.parse(factoryKEEY.interface.format("json")),
    USDTabi: JSON.parse(factoryUSDT.interface.format("json")),
    sellMyTokenabi: JSON.parse(factoryBuyContract.interface.format("json")),
  };
  fs.writeFileSync("frontend/src/Token.json", JSON.stringify(data));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
