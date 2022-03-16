const { expect } = require("chai");
const { ethers } = require("hardhat");

const DECIMALS = 10**18;
const KEEYPERUSDT = 10000;
describe("Smart Contract for Keey, USDT, Sale", () => {
    let keeyToken, KT, usdtToken, USDT, KTS, keeyTokenSale, owner, buyer;

    beforeEach(async () => {
        KT = await ethers.getContractFactory("KeeyToken");
        USDT = await ethers.getContractFactory("USDTToken");

        keeyToken = await KT.deploy();
        usdtToken = await USDT.deploy();
        KTS = await ethers.getContractFactory("KeeyTokenSale");
        keeyTokenSale = await KTS.deploy(keeyToken.address, usdtToken.address);
        [owner, buyer ] = await ethers.getSigners();

        //Transfer token to smc sale
        await keeyToken.transfer(keeyTokenSale.address, BigInt(1000*DECIMALS));
        await usdtToken.transfer(buyer.address, BigInt(100000*DECIMALS));
        
        await usdtToken.connect(buyer).approve(owner.address, BigInt(2*KEEYPERUSDT*DECIMALS));
        
        await keeyTokenSale.connect(owner).buyToken(BigInt(2*DECIMALS), buyer.address);
        
    });

    describe("Sale Smart Contract", () => {
        it("Should buy token properly", async () => {
            const balanceUSDTOfBuyerBig = await usdtToken.balanceOf(buyer.address);
            const balanceUSDTOfBuyer = Number(balanceUSDTOfBuyerBig/DECIMALS);

            const balanceKeeyOfBuyerBig = await keeyToken.balanceOf(buyer.address);
            const balanceKeeyOfBuyer = Number(balanceKeeyOfBuyerBig/DECIMALS);

            expect(80000).to.equal(balanceUSDTOfBuyer);
            expect(2).to.equal(balanceKeeyOfBuyer);
        });

        it("Should move rest of Keey from SMC Sale to Seller when trigger event EndSale", async () => {
            await keeyTokenSale.connect(owner).endSale();
            
            const balanceOfKTSBig = await keeyToken.balanceOf(keeyTokenSale.address);
            const balanceOfKTS = Number(balanceOfKTSBig/DECIMALS);

            const balanceOfOwnerBig = await keeyToken.balanceOf(owner.address);
            const balanceOfOwner = Number(balanceOfOwnerBig/DECIMALS);

            expect(0).to.equal(balanceOfKTS);
            expect(2498).to.equal(balanceOfOwner);

        });
    });
});
