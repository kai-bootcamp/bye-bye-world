const {expect} = require("chai");

describe("Sell contract", function(){
    let Token;
    let usdtContract;
    let keeyContract;
    let usdtOwner;
    let keeyOwner;
    let SellKEEY;
    let sellKEEYContract;
    const maxKEEY = 2500;
    beforeEach(async function(){
        Token = await ethers.getContractFactory("Token");
        [usdtOwner, keeyOwner] = await ethers.getSigners();
        usdtContract = await Token.connect(usdtOwner).deploy(100000000, "Tether", "USDT");
        keeyContract = await Token.connect(keeyOwner).deploy(2500, "IronSail", "KEEY");
        SellKEEY = await ethers.getContractFactory("SellKEEYToken");
        sellKEEYContract = await SellKEEY.connect(keeyOwner).deploy(keeyContract.address, usdtContract.address, 10000);
        // console.log(keeyOwner.address);
        // console.log(usdtOwner.address);
        // console.log(sellKEEYContract.address);
    });
    it("Test 0: Set right owner", async function(){
        expect(await usdtContract.owner()).to.equal(usdtOwner.address);
        expect(await keeyContract.owner()).to.equal(keeyOwner.address);
    });

    it("Test 1: init fund twice", async function(){
        const numberToken = 100;
        await keeyContract.approve(sellKEEYContract.address, numberToken * 2);
        await sellKEEYContract.initFund(numberToken);
        expect(await keeyContract.balanceOf(sellKEEYContract.address)).to.equal(numberToken);
        await sellKEEYContract.initFund(numberToken);
        console.log(await keeyContract.balanceOf(sellKEEYContract.address));
        expect(await keeyContract.balanceOf(sellKEEYContract.address)).to.equal(numberToken * 2);
    });

    it("Test 2: Set init 0", async function(){
        await expect(sellKEEYContract.initFund(0))
        .to.be.revertedWith("totalFunding is not positive");
    });

    it("Test 3: Set init bigger than balance", async function(){
        await keeyContract.approve(sellKEEYContract.address, maxKEEY + 1);
        expect(sellKEEYContract.initFund(maxKEEY + 1))
        .to.be.revertedWith("Balance is not enough for fund");
    });

    it("Test 4: Withdraw 0 token", async function(){
        await expect(sellKEEYContract.withdraw(0))
        .to.be.revertedWith("Amount is not positive");
    });

    it("Test 5: Withdraw bigger than balance", async function(){
        await keeyContract.approve(sellKEEYContract.address, maxKEEY);
        await sellKEEYContract.initFund(maxKEEY);
        await expect(sellKEEYContract.withdraw(maxKEEY + 1))
        .to.be.revertedWith("Remaining amount in contract is not enough for withdraw");
    });

    it("Test 6: Withdrawall twice", async function(){
        const numberToken = 10;
        await keeyContract.approve(sellKEEYContract.address, numberToken);
        await sellKEEYContract.initFund(numberToken);
        await sellKEEYContract.withdrawAll();
        await expect(sellKEEYContract.withdrawAll())
        .to.be.revertedWith("Remaining amount is not positive");
    })
});

describe("User buy KEEY", function(){
    let Token;
    let usdtContract;
    let keeyContract;
    let usdtOwner;
    let keeyOwner;
    let SellKEEY;
    let sellKEEYContract;
    const maxKEEY = 2500;
    const rate = 10000;
    beforeEach(async function(){
        Token = await ethers.getContractFactory("Token");
        [usdtOwner, keeyOwner] = await ethers.getSigners();
        usdtContract = await Token.connect(usdtOwner).deploy(100000000, "Tether", "USDT");
        keeyContract = await Token.connect(keeyOwner).deploy(2500, "IronSail", "KEEY");
        SellKEEY = await ethers.getContractFactory("SellKEEYToken");
        sellKEEYContract = await SellKEEY.connect(keeyOwner).deploy(keeyContract.address, usdtContract.address, rate);

        await keeyContract.approve(sellKEEYContract.address, maxKEEY);
        await sellKEEYContract.initFund(maxKEEY);
        // console.log(keeyOwner.address);
        // console.log(usdtOwner.address);
        // console.log(sellKEEYContract.address);
    });
    it("Test 1: User buy twice", async function(){
        const numberToken = 111;
        await usdtContract.connect(usdtOwner).approve(sellKEEYContract.address, numberToken * rate * 2);
        // console.log(await usdtContract.allowance(usdtOwner.address, sellKEEYContract.address))
        await sellKEEYContract.connect(usdtOwner).buyKEEY(numberToken);
        expect(await keeyContract.balanceOf(usdtOwner.address)).to.equal(numberToken);
        await sellKEEYContract.connect(usdtOwner).buyKEEY(numberToken);
        expect(await keeyContract.balanceOf(usdtOwner.address)).to.equal(numberToken * 2);
    });

    it("Test 2: User buy amount bigger than fund", async function(){
        const numberToken = maxKEEY + 1;
        await usdtContract.connect(usdtOwner).approve(sellKEEYContract.address, numberToken * rate);
        // console.log(await usdtContract.allowance(usdtOwner.address, sellKEEYContract.address))
        await expect(sellKEEYContract.connect(usdtOwner).buyKEEY(numberToken))
        .to.be.revertedWith("Amount remaining not enough!");
    });

    it.only("Test 3: User buy, seller withdraw all", async function(){
        const numberToken = 111;
        await usdtContract.connect(usdtOwner).approve(sellKEEYContract.address, numberToken * rate);
        // console.log(await usdtContract.allowance(usdtOwner.address, sellKEEYContract.address))
        await sellKEEYContract.connect(usdtOwner).buyKEEY(numberToken);
        await sellKEEYContract.connect(keeyOwner).withdrawAll();
        expect(await keeyContract.balanceOf(keeyOwner.address)).to.equal(maxKEEY - numberToken);
        expect(await usdtContract.balanceOf(keeyOwner.address)).to.equal(numberToken * rate);
    });
});