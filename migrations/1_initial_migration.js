
// const KeeyToken = artifacts.require("KeeyToken");
const KeeyTokenSale = artifacts.require("KeeyTokenSale");
// const USDTToken = artifacts.require("USDTToken");

module.exports = function (deployer) {
  // deployer.deploy(USDTToken);
  deployer.deploy(KeeyTokenSale, "0xe755a2048Fb976FA58A668D6f0dC23B5B38a9e08", "0x12BbFA5fc2677529Ef05024dD6584ad409316d9b");
};
