import { ethers } from "ethers";
import KeeyToken from "../build/contracts/KeeyToken.json";
import KeeyTokenSale from "../build/contracts/KeeyTokenSale.json";
import USDTToken from "../build/contracts/USDTToken.json";

let provider;
let signer;

export const load = async () => {
    provider = new ethers.providers.Web3Provider(window.ethereum, "any");
    await provider.send("eth_requestAccounts", []);
    signer = provider.getSigner();

    const account = await loadAccount();
    const { contractKeey, contractKTS, contractUSDT } = await loadContract();
    const { rate, fundsUSDT, myKeey, transactionCount, transactions } = await loadVariable(contractKTS, contractUSDT, contractKeey, account);

    return { account, contractKeey, contractKTS, contractUSDT, rate, fundsUSDT, myKeey, transactionCount, transactions };
}

const loadContract = async () => {
    const KeeyContract = new ethers.Contract(KeeyToken["networks"]["42"]["address"], KeeyToken.abi, signer);
    const ICOContract = new ethers.Contract(KeeyTokenSale["networks"]["42"]["address"], KeeyTokenSale.abi, signer);
    const USDTContract = new ethers.Contract(USDTToken["networks"]["42"]["address"], USDTToken.abi, signer);

    const contractKeey = await KeeyContract.deployed();
    const contractKTS = await ICOContract.deployed();
    const contractUSDT = await USDTContract.deployed();

    return {contractKeey, contractKTS, contractUSDT};
}

const loadAccount = async () => {
    const account = await signer.getAddress();
    return account;
}

const loadVariable = async (contractKTS, contractUSDT, contractKeey, account) => {
    const rateBigInt = await contractKTS.tokenPriceUSD();
    const rate = rateBigInt.toNumber();
    console.log("FUNDS: ", process.env.FUNDS_ADDRESS);
    const fundsUSDTWei = await contractUSDT.balanceOf('0x74756DAc944FD192Bb85a8A613918e107e3dcc85');
    const fundsUSDT = (fundsUSDTWei / 10**18).toFixed(0);
    const myKeeyWei = await contractKeey.balanceOf(account);
    console.log("my keey: ", myKeeyWei);
    const myKeey = myKeeyWei / 10**18;

    const transactionCount = await contractKTS.transactionCount();
    const transactions = [];
    let j = 0;
    for(let i=transactionCount - 1; i >= 0  && j < 10 ; i--) {
        const drawTransaction = await contractKTS.transaction(i);
        j++;
        const amountBigInt = drawTransaction.amount / 10**18;
        const transaction = {
            buyer: drawTransaction.buyer,
            amount: Number(amountBigInt)
        }
        transactions.push(transaction);
    }

    return { rate, fundsUSDT, myKeey, transactionCount, transactions };
}