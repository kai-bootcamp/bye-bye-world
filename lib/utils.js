import { ethers } from "ethers";
import KeeyToken from "../build/contracts/KeeyToken.json";
import KeeyTokenSale from "../build/contracts/KeeyTokenSale.json";
import USDTToken from "../build/contracts/USDTToken.json";
import { DECIMALS } from "./contants";

let provider;
let signer;

export const load = async () => {
  provider = new ethers.providers.Web3Provider(window.ethereum, "any");
  await provider.send("eth_requestAccounts", []);
  signer = provider.getSigner();
	const firstAccount = await signer.getAddress();
  const { contractKeey, contractKTS, contractUSDT } = await loadContract();
  const {
    rate,
    fundsUSDT,
    transactionCount,
    transactions,
    sellerAddress,
    balanceKeeyOfSale,
  } = await loadVariable(contractKTS, contractUSDT, contractKeey);
  const { account, myKeey } = await loadInfoAccount(firstAccount, contractKeey);

  return {
    account,
    contractKeey,
    contractKTS,
    contractUSDT,
    rate,
    fundsUSDT,
    myKeey,
    transactionCount,
    transactions,
    sellerAddress,
    balanceKeeyOfSale,
  };
};

const loadContract = async () => {
  const KeeyContract = new ethers.Contract(
    KeeyToken["networks"]["42"]["address"],
    KeeyToken.abi,
    signer
  );
  const ICOContract = new ethers.Contract(
    KeeyTokenSale["networks"]["42"]["address"],
    KeeyTokenSale.abi,
    signer
  );
  const USDTContract = new ethers.Contract(
    USDTToken["networks"]["42"]["address"],
    USDTToken.abi,
    signer
  );

  const contractKeey = await KeeyContract.deployed();
  const contractKTS = await ICOContract.deployed();
  const contractUSDT = await USDTContract.deployed();

  return { contractKeey, contractKTS, contractUSDT };
};

export const loadInfoAccount = async (account, contractKeey) => {
  const myKeeyWei = await contractKeey.balanceOf(account);
  const myKeey = myKeeyWei / DECIMALS;
  return { account, myKeey };
};

const loadVariable = async (contractKTS, contractUSDT, contractKeey) => {
  const rateBigInt = await contractKTS.tokenPriceUSD();
  const rate = rateBigInt.toNumber();
  const sellerAddress = await contractKTS.admin();
  const fundsUSDTWei = await contractUSDT.balanceOf(sellerAddress);
  const fundsUSDT = (fundsUSDTWei / DECIMALS).toFixed(0);

  const balanceKeeyOfSaleWei = await contractKeey.balanceOf(
    contractKTS.address
  );
  const balanceKeeyOfSale = balanceKeeyOfSaleWei / DECIMALS;
	console.log("check:", balanceKeeyOfSale);

  const transactionCount = await contractKTS.transactionCount();
  const transactions = [];
  let j = 0;
  for (let i = transactionCount - 1; i >= 0 && j < 10; i--) {
    const drawTransaction = await contractKTS.transaction(i);
    j++;
    const amountBigInt = drawTransaction.amount / DECIMALS;
    const transaction = {
      buyer: drawTransaction.buyer,
      amount: Number(amountBigInt),
    };
    transactions.push(transaction);
  }

  return {
    rate,
    fundsUSDT,
    transactionCount,
    transactions,
    sellerAddress,
    balanceKeeyOfSale
  };
};

export const getGasPriceInEth = async () => {
  const gasPrice = await provider.getGasPrice();

  return gasPrice / DECIMALS;
};
