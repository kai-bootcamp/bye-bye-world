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
  var keyToken;
  var usdtToken;
  var testToken;
  var ownerUSDT = accounts[5]
  var ownerKEEYS = accounts[6]
  var onwerTEST = accounts[7]
  var onwerPoolSaleToken = accounts[0]
  var onwerTokenFactory = accounts[0]


  it("should deploy pool sale token, create token test, create new sale token", async function () {
    poolSaleToken = await PoolSaleToken.deployed();
    const factory = await TokenFactory.deployed();
    await factory.create(poolSaleToken.address, "Bye bye Token", "KEEYS", "bafybeigzbuwqnhho6skbkz3vgivpoth4e7ipu6a5cebx3jaequ27y7g4ae", 0, 2500, { from: ownerKEEYS });
    await factory.create(poolSaleToken.address, "Test Token", "TEST", "bafybeigzbuwqnhho6skbkz3vgivpoth4e7ipu6a5cebx3jaequ27y7g4ae", 1, 25000, { from: onwerTEST });
    await factory.create(poolSaleToken.address, "Tether USDT", "USDT", "This is image of USDT", 2, 1000000, { from: ownerUSDT });
    keeyTokenAddress = await factory.tokenOf(ownerKEEYS);
    usdtTokenAddress = await factory.tokenOf(ownerUSDT);
    testTokenAddress = await factory.tokenOf(onwerTEST);
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
      10,
      50000,
      10, { from: ownerKEEYS }
    );

    await poolSaleToken.createTokenSale(
      testTokenAddress,
      usdtTokenAddress,
      await testToken.totalSupply(),
      1,
      100,
      50000,
      100, { from: onwerTEST }
    );

    var tokenSale = await poolSaleToken.tokenSaleInfo();
    /// check add token sale
    assert.equal(tokenSale[0].tokenSale, keeyTokenAddress);
    assert.equal(tokenSale[0].tokenBase, usdtTokenAddress);
    /// check owner of token sale
    assert.equal(await poolSaleToken.getOwnerOfTokenSale(0), ownerKEEYS);
    assert.equal(await poolSaleToken.getOwnerOfTokenSale(1), onwerTEST);
    /// check approve to pool sale contract.
    assert.equal(await keyToken.allowance(ownerKEEYS, poolSaleToken.address), 2500);
    assert.equal(await testToken.allowance(onwerTEST, poolSaleToken.address), 25000);

  });

  it("should buy token sale", async function () {
    await usdtToken.approve(poolSaleToken.address, 100000, { from: ownerUSDT })
    // hanle buy token KEEY -> 100 KEEY -> 100 Wei 
    await poolSaleToken.buySaleToken(0, 1100, { from: ownerUSDT });
    // check 
    assert.equal(await keyToken.balanceOf(ownerUSDT), 110)
    assert.equal(await usdtToken.balanceOf(ownerKEEYS), 1100)
    assert.equal(await keyToken.allowance(ownerKEEYS, poolSaleToken.address), 2500 - 110);
    assert.equal(await usdtToken.allowance(ownerUSDT, poolSaleToken.address), 100000 - 1100);

    // handle buy token TEST -> 1 TEST -> 10 Wei
    await poolSaleToken.buySaleToken(1, 1111, { from: ownerUSDT });

    assert.equal(await testToken.balanceOf(ownerUSDT), 11)
    assert.equal(await usdtToken.balanceOf(onwerTEST), 1100)
    assert.equal(await testToken.allowance(onwerTEST, poolSaleToken.address), 25000 - 11);
    assert.equal(await usdtToken.allowance(ownerUSDT, poolSaleToken.address), 100000 - 1100 - 1100);
  });

});
