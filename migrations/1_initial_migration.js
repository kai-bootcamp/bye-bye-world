// const Migrations = artifacts.require("Migrations");
const KeeyToken = artifacts.require("KeeyToken");
const KeeyTokenSale = artifacts.require("KeeyTokenSale");

module.exports = function (deployer) {
  // deployer.deploy(Migrations);
  // deployer.deploy(KeeyToken).then(() => {
  //   deployer.deploy(KeeyTokenSale, KeeyToken.address);
  // })
  deployer.deploy(KeeyTokenSale, "0xC74F4f35D04dfEbB746Ddac6f278b4ceE51805CF");
};
