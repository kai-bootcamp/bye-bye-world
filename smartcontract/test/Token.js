const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Keey contract", () => {
  let myToken, token, owner, person1, person2;

  beforeEach(async () => {
    myToken = await ethers.getContractFactory("Token");
    [owner, person1, person2, _] = await ethers.getSigners();
    token = await myToken.connect(owner).deploy(2500, "My Keey Token", "KEEY");
  });

  describe("Deployment", () => {
    it("Test1: Should get the right owner", async () => {
      expect(await token.owner()).to.equal(owner.address);
    });

    it("Test2: Should assign total supply for owner", async () => {
      const ownerBalance = await token.balanceOf(owner.address);
      expect(await token.totalSupply()).to.equal(ownerBalance);
    });
  });

  describe("Transactions", () => {
    it("Test3: Should transfer Keey tokens between addresses", async () => {
      await token.transfer(person1.address, 100);
      const person1Balance = await token.balanceOf(person1.address);
      expect(person1Balance).to.equal(100);

      await token.connect(person1).transfer(person2.address, 20);
      const person2Balance = await token.balanceOf(person2.address);
      expect(person2Balance).to.equal(20);
    });

    it("Test4: Should fail if sender doesnt have enough tokens", async () => {
      const initialBalanceOwner = await token.balanceOf(owner.address);

      await token.approve(person1.address, 20);
      await expect(
        token.connect(person1).transfer(owner.address, 20)
      ).to.be.revertedWith("transfer amount exceeds balance");

      expect(await token.balanceOf(owner.address)).to.equal(
        initialBalanceOwner
      );
    });

    it("Test5: Should update balances after transfers", async () => {
      const initialBalanceOwner = await token.balanceOf(owner.address);

      await token.transfer(person1.address, 69);
      await token.transfer(person2.address, 96);

      const finalOnwerBalance = await token.balanceOf(owner.address);
      expect(finalOnwerBalance).to.equal(initialBalanceOwner - 165);

      const person1Balance = await token.balanceOf(person1.address);
      expect(person1Balance).to.equal(69);

      const person2Balance = await token.balanceOf(person2.address);
      expect(person2Balance).to.equal(96);
    });
  });
});
