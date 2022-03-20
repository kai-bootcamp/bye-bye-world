import { useState, useEffect } from "react";
import "./App.css";
import Token from "./Token.json";
import { ethers } from "ethers";
import {
  getContract,
  connectWallet,
  getCurrentBalanceToken,
} from "./util/interact";
const priceRate = 10000;

function App() {
  const [USDT, setUSDT] = useState();
  const [KEEY, setKEEY] = useState();
  const [buyContract, setBuyContract] = useState();

  const [walletAddress, setWallet] = useState("");
  const [status, setStatus] = useState("");

  const [amount, setAmount] = useState(0);
  const [payment, setPayment] = useState(0);
  const [error, setError] = useState(false);
  const [owner, setOwner] = useState("");

  const ethereum = window.ethereum;

  useEffect(() => {
    const init = async () => {
      const { USDTContract, KEEYContract, buyContract } = await getContract();
      setUSDT(USDTContract);
      setKEEY(KEEYContract);
      setBuyContract(buyContract);
    };
    init();
  }, []);

  const connectWalletPressed = async () => {
    const walletAddress = await connectWallet();
    const ownerAddress = await buyContract.owner();
    setWallet(walletAddress);
    setOwner(ownerAddress);
    setStatus("Wallet Connected");
  };

  const getCurrentBalance = async () => {
    const { USDTbalance, KEEYbalance } = await getCurrentBalanceToken(
      USDT,
      KEEY,
      walletAddress
    );

    setStatus(
      `Balance 
      - USDT: ${ethers.utils.formatEther(USDTbalance, {
        commify: true,
      })}
      - KEEY: ${ethers.utils.formatEther(KEEYbalance, {
        commify: true,
      })}`
    );
  };

  const calculateUSDTAmount = (event) => {
    let value = event.target.value;
    let nonDigitCharacters = /[a-z\A-Z`!@#$%^&*()_+\-=\[\]{};':"\\|,<>\/?~]/;
    let dotCheck = /[^.]/g;
    let afterComma = value.toString().split(".")[1];
    if (nonDigitCharacters.test(value.toString())) {
      console.log("Error: Have non digit characters!");
      setError(true);
    } else if (value.toString().replace(dotCheck, "").length > 1) {
      console.log("Error: Have more than 1 comma!");
      setError(true);
    } else if (afterComma && afterComma.length > 4) {
      console.log("Error: Have more than 4 decimals!");
      setError(true);
    } else {
      setError(false);
    }

    setAmount(value);
    setPayment(value * priceRate);
  };

  const buyKeey = async () => {
    if (amount <= 0) {
      alert("Amount must be greater than 0");
    } else {
      if (ethereum) {
        let additionalZeros, newAmount, newPayment;
        if (amount % 1 !== 0) {
          let afterComma = amount.toString().split(".")[1];
          additionalZeros = "";
          for (let i = 0; i < 18 - afterComma.length; i++) {
            additionalZeros += "0";
          }
          newAmount = amount.toString().replace(/[^0-9]/, "") + additionalZeros;
        } else {
          additionalZeros = "000000000000000000";
          newAmount = amount + additionalZeros;
        }
        newPayment = payment.toString() + "000000000000000000";

        try {
          const approveResponse = await USDT.approve(
            Token.sellMyTokenaddress,
            newPayment
          );
          setStatus("Waiting to be approved");
          const approveResult = await approveResponse.wait();
          if (approveResult.status !== 1) {
            setStatus("Failed approve");
            throw new Error("Failed approve");
          }
          setStatus("Approved! Waiting to buy KEEY");

          const buyResponse = await buyContract.buyKEEY(newAmount);
          setStatus("Buying Keey Token");
          const buyResult = await buyResponse.wait();

          if (buyResult.status !== 1) {
            setStatus("Failed buy");
            throw new Error("Failed buy");
          }
          getCurrentBalance();
        } catch (error) {
          setStatus("Error");
          console.log("error", error);
          return;
        }
      }
    }
  };

  return (
    <div className="app">
      <div className="container">
        <h2 className="title">Buy KEEY to seal the deal</h2>
        <button className="wallet-button" onClick={connectWalletPressed}>
          {walletAddress.length > 0 ? (
            "Connected: " +
            String(walletAddress).substring(0, 6) +
            "..." +
            String(walletAddress).substring(38)
          ) : (
            <span>Connect Wallet</span>
          )}
        </button>

        {walletAddress !== "" && (
          <>
            <button className="button" onClick={getCurrentBalance}>
              Get Current Balances
            </button>
            <div className="buy-section">
              <input
                id="buyAmount"
                type="text"
                placeholder="Exchange ratio: 1 KEEY = 10000 USDT"
                onChange={(e) => calculateUSDTAmount(e)}
              />
              <p>
                USDT need:{" "}
                {amount === 0 || error === true ? "..." : amount * priceRate}
              </p>
            </div>
            <button
              className={error ? "button disable" : "button"}
              onClick={buyKeey}
              disabled={error}
            >
              Buy KEEY
            </button>
          </>
        )}

        <p id="status">{status}</p>
      </div>
    </div>
  );
}

export default App;
