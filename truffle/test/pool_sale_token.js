const PoolSaleToken = artifacts.require("PoolSaleToken");
const TokenFactory = artifacts.require("TokenFactory");
const Token = artifacts.require("Token");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("PoolSaleToken", function (accounts) {
  var poolSaleToken;
  it("should deploy pool sale token, create token test, create new sale token", async function () {
    poolSaleToken = await PoolSaleToken.deployed();
    const factory = await TokenFactory.deployed();
    await factory.create(poolSaleToken.address, "Bye bye Token", "KEEYS", "bafybeigzbuwqnhho6skbkz3vgivpoth4e7ipu6a5cebx3jaequ27y7g4ae", 0, 2500, { from: accounts[0] });
    await factory.create(poolSaleToken.address, "Test Token", "TEST", "bafybeigzbuwqnhho6skbkz3vgivpoth4e7ipu6a5cebx3jaequ27y7g4ae", 0, 25000, { from: accounts[2] });
    await factory.create(poolSaleToken.address, "Tether USDT", "USDT", "This is image of USDT", 6, 1000000000000, { from: accounts[1] });
    keeyTokenAddress = await factory.tokenOf(accounts[0]);
    usdtTokenAddress = await factory.tokenOf(accounts[1]);
    testTokenAddress = await factory.tokenOf(accounts[2]);
    keyToken = await Token.at(keeyTokenAddress);
    usdtToken = await Token.at(usdtTokenAddress);
    testToken = await Token.at(testTokenAddress);
    // check create token 
    assert.equal("Bye bye Token", await keyToken.name());
    assert.equal("Tether USDT", await usdtToken.name());
    assert.equal("Test Token", await testToken.name());
    await poolSaleToken.createTokenSale(
      keeyTokenAddress,
      usdtTokenAddress,
      await keyToken.totalSupply(),
      1,
      10 ** 10,
      500 * 10 ** 10,
      10 ** 10, { from: accounts[0] }
    );

    await poolSaleToken.createTokenSale(
      testTokenAddress,
      usdtTokenAddress,
      await testToken.totalSupply(),
      1,
      10 ** 10,
      500 * 10 ** 10,
      10 ** 10, { from: accounts[1] }
    );

    var tokenSale = await poolSaleToken.tokenSaleInfo();
    /// check add token sale
    assert.equal(tokenSale[0].tokenSale, keeyTokenAddress);
    assert.equal(tokenSale[0].tokenBase, usdtTokenAddress);
    /// check owner of token sale
    assert.equal(await poolSaleToken.getOwnerOfTokenSale(0), accounts[0]);
    assert.equal(await poolSaleToken.getOwnerOfTokenSale(1), accounts[1]);
    /// check approve to pool sale contract.
    console.log(poolSaleToken.address);
    assert.equal(await keyToken.allowance(accounts[0], poolSaleToken.address), 2500);
    assert.equal(await testToken.allowance(accounts[2], poolSaleToken.address), 25000);

  });
});
