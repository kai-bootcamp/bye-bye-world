const TokenFactory = artifacts.require("TokenFactory");

module.exports = function (_deployer) {
  // Use deployer to state migration tasks.
  _deployer.deploy(TokenFactory)
};
