const PoolSaleToken = artifacts.require("PoolSaleToken");

module.exports = function (_deployer) {
  // Use deployer to state migration tasks.
  _deployer.deploy(PoolSaleToken);
};
