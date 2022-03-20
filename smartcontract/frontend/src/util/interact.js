import Token from "../Token.json";
import { ethers, Contract } from "ethers";

export const getContract = async () => {
  if (window.ethereum) {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();

    const KEEYContract = new Contract(Token.KEEYaddress, Token.KEEYabi, signer);
    const USDTContract = new Contract(Token.USDTaddress, Token.USDTabi, signer);
    const buyContract = new Contract(
      Token.sellMyTokenaddress,
      Token.sellMyTokenabi,
      signer
    );
    return { KEEYContract, USDTContract, buyContract };
  } else {
    return {
      KEEYContract: undefined,
      USDTContract: undefined,
      buyContract: undefined,
    };
  }
};

export const connectWallet = async () => {
  if (window.ethereum) {
    try {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      await provider.send("eth_requestAccounts", []);
      const addressArray = await window.ethereum.request({
        method: "eth_requestAccounts",
      });
      return addressArray[0];
    } catch (error) {
      console.log("error", error);
    }
  }
};

export const getCurrentBalanceToken = async (
  USDTContract,
  KEEYContract,
  walletAddress
) => {
  try {
    const USDTbalance = (
      await USDTContract.balanceOf(walletAddress)
    ).toString();
    const KEEYbalance = (
      await KEEYContract.balanceOf(walletAddress)
    ).toString();
    return {
      USDTbalance,
      KEEYbalance,
    };
  } catch (err) {
    console.log("error: ", err);
  }
};
