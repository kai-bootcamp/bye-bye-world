async function main() {
  const [keeyOwner, usdtOwner] = await ethers.getSigners();

  console.log("keeyOwner address:", keeyOwner.address);
  console.log("keeyOwner balance:", (await keeyOwner.getBalance()).toString());

  console.log("usdtOwner address:", usdtOwner.address);
  console.log("usdtOwner balance:", (await usdtOwner.getBalance()).toString());
  
  const Token = await ethers.getContractFactory("Token");
  const TokenSale = await ethers.getContractFactory("TokenSale");

  const usdtToken = await Token.connect(usdtOwner).deploy(1000000000, "USDT token", "USDT");
  console.log("usdtToken address:", usdtToken.address);

  const keeyToken = await Token.connect(keeyOwner).deploy(2500, "Ironsail token", "KEEY");
  console.log("keeyToken address:", keeyToken.address);

  const currentTime = Math.round(new Date().getTime() / 1000);
  const endingTime = currentTime + 24 * 60 * 60; // 60 mins

  const tokenSale = await TokenSale.connect(keeyOwner).deploy(keeyToken.address, usdtToken.address, 10000);
  await keeyToken.connect(keeyOwner).approve(tokenSale.address, 2500);
  await tokenSale.connect(keeyOwner).startSale(endingTime);

  console.log("tokenSale address:", tokenSale.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
