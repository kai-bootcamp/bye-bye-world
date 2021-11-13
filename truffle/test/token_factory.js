const TokenFactory = artifacts.require("TokenFactory");
const Token = artifacts.require("Token");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("TokenFactory", function (accounts) {
  var newToken
  it("should create KEEY token", async function () {
    const factory = await TokenFactory.deployed();
    await factory.create("0x8f0483125FCb9aaAEFA9209D8E9d7b9C8B9Fb90F", "Bye bye Token", "KEEYS", "bafybeigzbuwqnhho6skbkz3vgivpoth4e7ipu6a5cebx3jaequ27y7g4ae", 0, 2500);
    newAddressToken = await factory.tokenOf(accounts[0])
    newToken = await Token.at(newAddressToken)
    assert.equal("Bye bye Token", await newToken.name())
    assert.equal("KEEYS", await newToken.symbol())
    assert.equal("bafybeigzbuwqnhho6skbkz3vgivpoth4e7ipu6a5cebx3jaequ27y7g4ae", await factory.tokenUrl(newAddressToken));
    assert.equal(accounts[0], await newToken.creator())
    assert.equal(2500, await newToken.totalSupply())
    assert.equal(0, await newToken.decimals())
    assert.equal(2500, await newToken.balanceOf(accounts[0]))
  });

  it("should transfer KEEY token", async function () {
    let result = await newToken.transfer(accounts[1], 100, { from: accounts[0] })
    assert.equal(100, await newToken.balanceOf(accounts[1]))
    assert.equal(2400, await newToken.balanceOf(accounts[0]))
  });

});
