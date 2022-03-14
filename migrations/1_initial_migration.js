
const KeeyToken = artifacts.require("KeeyToken");
const KeeyTokenSale = artifacts.require("KeeyTokenSale");
const USDTToken = artifacts.require("USDTToken");

module.exports = async function (deployer) {
  await  deployer.deploy(KeeyToken);
  await deployer.deploy(USDTToken);
  await deployer.deploy(KeeyTokenSale, KeeyToken.address, USDTToken.address);
};
