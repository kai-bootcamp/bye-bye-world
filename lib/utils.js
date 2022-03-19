import { ethers } from "ethers";
import KeeyToken from "../build/contracts/KeeyToken.json";
import KeeyTokenSale from "../build/contracts/KeeyTokenSale.json";
import USDTToken from "../build/contracts/USDTToken.json";
import { DECIMALS, SELLER_ADDRESS } from "./contants";

export const load = async () => {
  const provider = new ethers.providers.Web3Provider(window.ethereum, "any");

  const { contractKeey, contractKTS, contractUSDT } = await loadContract(provider);
  const {
    fundsUSDT,
    transactionCount,
    transactions,
    balanceKeeyOfSale,
  } = await loadVariable(contractKTS, contractUSDT, contractKeey);

  return {
    provider,
    contractKeey,
    contractKTS,
    contractUSDT,
    fundsUSDT,
    transactionCount,
    transactions,
    balanceKeeyOfSale,
  };
};

export const loadContract = async (provider) => {
  const contractKeey = new ethers.Contract(
    KeeyToken["networks"]["42"]["address"],
    KeeyToken.abi,
    provider
  );
  const contractKTS = new ethers.Contract(
    KeeyTokenSale["networks"]["42"]["address"],
    KeeyTokenSale.abi,
    provider
  );
  const contractUSDT = new ethers.Contract(
    USDTToken["networks"]["42"]["address"],
    USDTToken.abi,
    provider
  );

  return { contractKeey, contractKTS, contractUSDT };
};

export const loadInfoAccount = async (account, contractKeey) => {
  const myKeeyWei = await contractKeey.balanceOf(account);
  const myKeey = myKeeyWei / DECIMALS;
  return { account, myKeey };
};

const loadVariable = async (contractKTS, contractUSDT, contractKeey) => {
  const fundsUSDTWei = await contractUSDT.balanceOf(SELLER_ADDRESS);
  const fundsUSDT = (fundsUSDTWei / DECIMALS).toFixed(0);

  const balanceKeeyOfSaleWei = await contractKeey.balanceOf(
    contractKTS.address
  );
  const balanceKeeyOfSale = balanceKeeyOfSaleWei / DECIMALS;

  const transactionCountBig = await contractKTS.transactionCount();
  const transactionCount = transactionCountBig.toNumber();
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
    fundsUSDT,
    transactionCount,
    transactions,
    balanceKeeyOfSale
  };
};
