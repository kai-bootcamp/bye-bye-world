// We import Chai to use its asserting functions here.
const { expect } = require("chai");
const { BigNumber } = require("ethers");

// when the contract is activated
   // when the contract is not paused
      // when the offering period has started
         // when the offering period has not ended
            // it should return true


describe("Token contract", function () {
  let Token;
  let usdtToken;
  let owner;
  let receiver;
   // `beforeEach` will run before each test, re-deploying the contract every
  // time. It receives a callback, which can be async.
  beforeEach(async function (){
      Token = await ethers.getContractFactory("Token");
      [owner, receiver] = await ethers.getSigners();
      usdtToken = await Token.connect(owner).deploy(1111, "Tether", "USDT");
  });

  describe("Deployment", function(){
    // `it` is another Mocha function. This is the one you use to define your
    // tests. It receives the test name, and a callback function.

    it("Test 1: set the right owner", async function(){
      // Expect receives a value, and wraps it in an Assertion object. These
      // objects have a lot of utility methods to assert values.

      // This test expects the owner variable stored in the contract to be equal
      // to our Signer's owner.
      expect(await usdtToken.owner()).to.equal(owner.address);
    });

    it("Test 2: assign total supply to owner", async function(){
      const ownerBalance = await usdtToken.balanceOf(owner.address);
      expect(await usdtToken.totalSupply()).to.equal(ownerBalance);
    });
  });

  describe("Transactions", function(){
    it("Test 1: transfer token between accounts", async function(){
      //Transfer 50 tokens from owner to receiver
      await usdtToken.transfer(receiver.address, 50);
      const receiverToken = await usdtToken.balanceOf(receiver.address);
      expect(receiverToken).to.equal(50);
    });
  });
});

