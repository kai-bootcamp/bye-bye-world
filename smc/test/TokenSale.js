const { ethers } = require("hardhat");
// We import Chai to use its asserting functions here.
const { expect } = require("chai");

// `describe` is a Mocha function that allows you to organize your tests. It's
// not actually needed, but having your tests organized makes debugging them
// easier. All Mocha functions are available in the global scope.

// `describe` receives the name of a section of your test suite, and a callback.
// The callback must define the tests of that section. This callback can't be
// an async function.
describe("Token sale contract", function () {
  // Mocha has four functions that let you hook into the the test runner's
  // lifecyle. These are: `before`, `beforeEach`, `after`, `afterEach`.

  // They're very useful to setup the environment for tests, and to clean it
  // up after they run.

  // A common pattern is to declare some variables, and assign them in the
  // `before` and `beforeEach` callbacks.

  let Token, TokenSale;
  let keeyToken, usdtToken;
  let keeyOwner;
  let usdtOwner;
  let tokenSale;
  let addr1;
  let addr2;
  let addrs;
  let currentTime;
  let endingTime;

  // `beforeEach` will run before each test, re-deploying the contract every
  // time. It receives a callback, which can be async.
  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    Token = await ethers.getContractFactory("Token");
    TokenSale = await ethers.getContractFactory("TokenSale");
    [keeyOwner, usdtOwner, addr1, addr2, ...addrs] = await ethers.getSigners();

    // To deploy our contract, we just have to call Token.deploy() and await
    // for it to be deployed(), which happens once its transaction has been
    // mined.
    usdtToken = await Token.connect(usdtOwner).deploy(1000000000, "USDT token", "USDT");
    keeyToken = await Token.connect(keeyOwner).deploy(2500, "Ironsail token", "KEEY");

    currentTime = Math.round(new Date().getTime() / 1000);
    endingTime = currentTime + 60 * 60; // 60 mins

    tokenSale = await TokenSale.connect(keeyOwner).deploy(keeyToken.address, usdtToken.address, 10000);
    await keeyToken.connect(keeyOwner).approve(tokenSale.address, 2500);
    await tokenSale.connect(keeyOwner).startSale(endingTime);

    // Send initial USDT to addresses
    await usdtToken.connect(usdtOwner).transfer(addr1.address, 50000);
    await usdtToken.connect(usdtOwner).transfer(addr2.address, 100000);
  });

  describe("Deployment", function () {
    it("Should set right address for token contracts", async function () {
      expect(await tokenSale.keeyContract()).to.equal(keeyToken.address);
      expect(await tokenSale.usdtContract()).to.equal(usdtToken.address);
    });
    it("Should transfer all tokens from owner to sale contract", async function() {
      const keeyOwnerBalance = await keeyToken.balanceOf(keeyOwner.address);

      expect(keeyOwnerBalance).to.equal(0);
      expect(await keeyToken.balanceOf(tokenSale.address)).to.equal(2500);
      expect(await tokenSale.remainingToken()).to.equal(2500);

      expect(await keeyToken.balanceOf(keeyOwner.address)).to.equal(0);

      expect(await tokenSale.collectedUsdt()).to.equal(0);
    })
    it("Should set the right ending time", async function() {
      expect(await tokenSale.endTimestamp()).to.equal(endingTime);
    })
  })

  // Enough money => transfer right amount of money and token
  describe("Buy with enough USDT", function () {
    it("Should buy success", async function() {
      await usdtToken.connect(addr1).approve(tokenSale.address, 50000);
      await tokenSale.connect(addr1).buyTokens(5);

      expect(await keeyToken.balanceOf(addr1.address)).to.equal(5);
      expect(await keeyToken.balanceOf(tokenSale.address)).to.equal(2500 - 5);
      
      expect(await tokenSale.remainingToken()).to.equal(2500 - 5);
      
      expect(await tokenSale.collectedUsdt()).to.equal(50000);
      expect(await usdtToken.balanceOf(tokenSale.address)).to.equal(50000);
    })
  })

  // Not enough money => reject buying
  describe("Buy with not enough USDT", function () {
    it("Should buy fail", async function () {
      await usdtToken.connect(addr1).approve(tokenSale.address, 30000);
      await expect(tokenSale.connect(addr1).buyTokens(5)).to.be.revertedWith("You must approve this contract consume enough amount of USDT");
    })
  })

  describe("End sale", function () {
    it("Should not allow end sale before ending time", async function () {
      await expect(tokenSale.connect(keeyOwner).endSale()).to.be.revertedWith("Sale did not end");
    })

    it("Should allow ending sale", async function () {
      await usdtToken.connect(addr1).approve(tokenSale.address, 50000);
      await tokenSale.connect(addr1).buyTokens(5);

      await usdtToken.connect(addr2).approve(tokenSale.address, 100000);
      await tokenSale.connect(addr2).buyTokens(7);


      await ethers.provider.send('evm_increaseTime', [60*60]);
      await ethers.provider.send('evm_mine');

      await tokenSale.connect(keeyOwner).endSale();

      expect(await keeyToken.balanceOf(keeyOwner.address)).to.equal(0);
      expect(await keeyToken.balanceOf(tokenSale.address)).to.equal(0);
  
      expect(await usdtToken.balanceOf(tokenSale.address)).to.equal(0);
      expect(await usdtToken.balanceOf(keeyOwner.address)).to.equal(50000 + 70000);

      expect(await keeyToken.totalSupply()).to.equal(12);
    })
  })

  // Buy after ending time => reject
  describe("Buy after ending time", function () {
    it("Should buy fail after ending sale time", async function () {
      const exceededTime = endingTime + 100 * 60;
      await ethers.provider.send('evm_setNextBlockTimestamp', [exceededTime]);
      await ethers.provider.send('evm_mine');

      await usdtToken.connect(addr1).approve(tokenSale.address, 50000);
      await expect(tokenSale.connect(addr1).buyTokens(5)).to.be.revertedWith("Token sale ended");
    })
  })
});