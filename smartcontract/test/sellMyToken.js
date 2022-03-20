const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("sell Keey contract", () => {
  let Token, usdtOwner, keeyOwner, USDT, KEEY, factorySellMyToken, sellMyToken;
  let priceRate = 10000;
  let maximumKeey = 2500;
  let maximumUSDT = 50000000;

  beforeEach(async () => {
    Token = await ethers.getContractFactory("Token");
    [keeyOwner, usdtOwner] = await ethers.getSigners();
    KEEY = await Token.connect(keeyOwner).deploy(
      maximumKeey,
      "My Keey Token",
      "KEEY"
    );
    USDT = await Token.connect(usdtOwner).deploy(maximumUSDT, "Tether", "USDT");
    factorySellMyToken = await ethers.getContractFactory("sellMyToken");
    sellMyToken = await factorySellMyToken
      .connect(keeyOwner)
      .deploy(KEEY.address, USDT.address, priceRate);
  });

  describe("Owners and funds", () => {
    it("Test1: Set owners", async () => {
      expect(await USDT.owner()).to.equal(usdtOwner.address);
      expect(await KEEY.owner()).to.equal(keeyOwner.address);
    });

    it("Test2: Initial deposit", async () => {
      await KEEY.approve(sellMyToken.address, 500);
      await sellMyToken.deposit(500);

      expect(await KEEY.balanceOf(sellMyToken.address)).to.equal(500);
    });

    it("Test3: Set bigger fund than keey balance", async () => {
      await KEEY.approve(sellMyToken.address, 500);
      expect(sellMyToken.deposit(501)).to.be.revertedWith(
        "Balance is not enough"
      );
    });

    it("Test4: Set initial deposit by 0", async () => {
      await expect(sellMyToken.deposit(0)).to.be.revertedWith(
        "Cannot deposit 0 or smaller amount"
      );
    });

    it("Test5: Set price rate again", async () => {
      await sellMyToken.setPriceRate(5000);
      expect(await sellMyToken.getPriceRate()).to.equal(5000);
    });
  });

  describe("Buy", () => {
    beforeEach(async () => {
      await KEEY.approve(sellMyToken.address, maximumKeey);
      await sellMyToken.deposit(maximumKeey);
    });

    it("Test6: User buy an amount of KEEY", async () => {
      await USDT.connect(usdtOwner).approve(
        sellMyToken.address,
        500 * priceRate
      );
      await sellMyToken.connect(usdtOwner).buyKEEY(100);
      expect(await KEEY.balanceOf(usdtOwner.address)).to.equal(100);
    });

    it("Test7: User buy more than initial fund", async () => {
      await USDT.connect(usdtOwner).approve(
        sellMyToken.address,
        (maximumKeey + 1) * priceRate
      );
      await sellMyToken.connect(usdtOwner).buyKEEY(maximumKeey + 1);
      expect(await KEEY.balanceOf(usdtOwner.address)).to.equal(maximumKeey);
    });
  });

  describe("Withdraw", () => {
    beforeEach(async () => {
      await KEEY.approve(sellMyToken.address, maximumKeey);
      await sellMyToken.deposit(maximumKeey);
    });

    it("Test8: Withdraw an amount", async () => {
      await USDT.connect(usdtOwner).approve(
        sellMyToken.address,
        100 * priceRate
      );
      await sellMyToken.connect(usdtOwner).buyKEEY(100);
      expect(await KEEY.balanceOf(usdtOwner.address)).to.equal(100);
      await sellMyToken.connect(usdtOwner).withdraw(100, usdtOwner.address);
      expect(await USDT.balanceOf(usdtOwner.address)).to.equal(
        maximumUSDT - 100 * priceRate
      );
    });

    it("Test9: Withdraw all", async () => {
      await USDT.connect(usdtOwner).approve(
        sellMyToken.address,
        100 * priceRate
      );
      await sellMyToken.connect(usdtOwner).buyKEEY(100);
      expect(await KEEY.balanceOf(usdtOwner.address)).to.equal(100);
      expect(await USDT.balanceOf(keeyOwner.address)).to.equal(100 * priceRate);
      await sellMyToken.connect(keeyOwner).withdrawAll();
      expect(await KEEY.balanceOf(keeyOwner.address)).to.equal(
        maximumKeey - 100
      );
    });

    it("Test10: Withdraw more than remaining tokens", async () => {
      await expect(
        sellMyToken.withdraw(maximumKeey + 1, keeyOwner.address)
      ).to.be.revertedWith("ERC20: transfer amount exceeds balance");
    });

    it("Test11: Withdraw 0 token", async () => {
      await expect(sellMyToken.withdraw(0, keeyOwner.address)).to.be.reverted;
    });
  });
});
