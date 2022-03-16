import Head from "next/head";
import Image from "next/image";
import { load, loadInfoAccount } from "../lib/utils";
import styles from "../styles/Home.module.css";
import React, { useState, useEffect } from "react";
import { ethers } from "ethers";
import { DECIMALS, TOTAL_KEEY_SALE } from "../lib/contants";

export default function Home() {
  const [account, setAccount] = useState(null);
  const [contractKeey, setContractKeey] = useState(null);
  const [contractKTS, setContractKTS] = useState(null);
  const [contractUSDT, setContractUSDT] = useState(null);
  const [rate, setRate] = useState(0);
  const [fundsUSDT, setFundsUSDT] = useState(-1);
  const [myKeey, setMyKeey] = useState(-1);
  const [transactions, setTransactions] = useState(undefined);
  const [value, setValue] = useState(0);
  const [sellerAddress, setSellerAddress] = useState("");
  const [balanceKeeyOfSale, setBalanceKeeyOfSale] = useState(-1);
  const [waiting, setWaiting] = useState(false);

  const handleInput = (e) => {
    setValue(e.currentTarget.value);
  };

  const isLoading = () => {
    return (
      account == null ||
      contractKTS == null ||
      contractKeey == null ||
      contractUSDT == null ||
      rate == 0 ||
      fundsUSDT < 0 ||
      myKeey < 0 ||
      transactions === undefined ||
      sellerAddress === "" ||
      balanceKeeyOfSale < 0
    );
  };

  const handleUseEffect = async () => {
    load().then((data) => {
      console.log(data);
      setAccount(data.account);
      setContractKTS(data.contractKTS);
      setContractKeey(data.contractKeey);
      setContractUSDT(data.contractUSDT);
      setRate(data.rate);
      setFundsUSDT(data.fundsUSDT);
      setMyKeey(data.myKeey);
      setTransactions(data.transactions);
      setSellerAddress(data.sellerAddress);
      setBalanceKeeyOfSale(data.balanceKeeyOfSale);

      window.ethereum.on("accountsChanged", async (accounts) => {
        const { account, myKeey } = await loadInfoAccount(accounts[0], data.contractKeey);
        setAccount(account);
        setMyKeey(myKeey);
      });
    });
  };

  const handleBuyToken = async () => {
    if (value <= 0) {
      alert("Value must not less than or equal to 0!");
      return;
    }
    setWaiting(true);
    await approveUSDT();
    const amountToken = ethers.BigNumber.from(BigInt(DECIMALS)).mul(value);
    await contractKTS.buyToken(amountToken, account, {
      from: account,
      value: 0,
      gasLimit: 500000,
    });
    contractKTS.on("Sell", (value) => {
      console.log("Sell success: ", value);
      alert("Buy token successfully");
      setWaiting(false);
      handleUseEffect();
    });
  };

  const approveUSDT = async () => {
    const approveAmount = ethers.BigNumber.from(BigInt(DECIMALS)).mul(
      rate * value
    );
    await contractUSDT.approve(sellerAddress, approveAmount, {
      from: account,
      value: 0,
      gasLimit: 500000,
    });

    contractUSDT.on("Approval", async (owner, spender, amount) => {
      console.log("Approval successfully");
      console.log({ owner, spender, amount });
    });
  };

  const getProcessPercent = () => {
    return (
      ((TOTAL_KEEY_SALE - balanceKeeyOfSale) / TOTAL_KEEY_SALE).toFixed(2) *
        100 +
      "%"
    );
  };

  const handleEndSale = async () => {
    if(balanceKeeyOfSale === 0) {
      alert("Token Keey was sold all!");
      return;
    }
    setWaiting(true);
    await contractKTS.endSale({
      from: account,
      value: 0,
      gasLimit: 500000,
    });
    contractKTS.on("EndSale", (amount) => {
      alert(`Get ${amount/DECIMALS} Keey back to seller address successfully!`);
      setWaiting(false);
      handleUseEffect();
    });
  }

  useEffect(() => {
    handleUseEffect();
  }, []);

  return (
    <div className={styles.container}>
      <Head>
        <title>ICO Keey</title>
        <meta name="description" content="Keey Token ICO" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>
          Welcome to{" "}
          <a href="https://kovan.etherscan.io/token/0xe755a2048fb976fa58a668d6f0dc23b5b38a9e08">
            Keey
          </a>{" "}
          ICO
        </h1>
        {isLoading() ? (
          <p className={styles.description}>Loading....</p>
        ) : (
          <>
            <p className={styles.description}>
              1 Keey = {rate} USDT {"  "}
              {account.toLowerCase() === sellerAddress.toLowerCase() && <button className={`${styles.button} ${styles.button_secondary}`} onClick={handleEndSale}>End Sale</button>}
            </p>
            <div className={styles.progress_wrapper}>
              <p className={styles.progress_content}>
                {TOTAL_KEEY_SALE - balanceKeeyOfSale}/{TOTAL_KEEY_SALE} Keey
              </p>
              <div
                className={styles.progress_percent}
                style={{ width: getProcessPercent() }}
              ></div>
            </div>
            <div className={styles.description}>
              {waiting ? (
                <p>Please wait! Transaction is in progress....</p>
              ) : (
                <>
                  <div>
                    <input
                      type="number"
                      placeholder="Amount Keey"
                      className={styles.input}
                      value={value}
                      onChange={handleInput}
                    />
                    <button className={styles.button} onClick={handleBuyToken}>
                      Buy Keey
                    </button>
                  </div>
                  <p style={{ fontSize: "1rem" }}>My Address: {account}</p>
                </>
              )}
            </div>

            <div className={styles.grid}>
              <div className={styles.card}>
                <h2>Information &rarr;</h2>
                <p>Transactions: {transactions.length}</p>
                <p>Funds: {fundsUSDT} USDT</p>
                <p>My Keey: {myKeey} KEEY</p>
              </div>

              <div className={styles.card}>
                <h2>Last 10 transactions &rarr;</h2>
                {/* <pre>{JSON.stringify(transactions)}</pre> */}
                <table className={styles.table}>
                  <thead>
                    <tr>
                      <th className={styles.th}>Address</th>
                      <th className={styles.th}>Amount</th>
                    </tr>
                  </thead>

                  <tbody>
                    {transactions.map((transaction, index) => {
                      return (
                        <tr key={index} className={styles.tr}>
                          <td className={styles.td}>{transaction.buyer}</td>
                          <td className={styles.td}>{transaction.amount}</td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            </div>
          </>
        )}
      </main>

      <footer className={styles.footer}>
        <a
          href="https://vercel.com?utm_source=create-next-app&utm_medium=default-template&utm_campaign=create-next-app"
          target="_blank"
          rel="noopener noreferrer"
        >
          Powered by{" "}
          <span className={styles.logo}>
            <Image src="/vercel.svg" alt="Vercel Logo" width={72} height={16} />
          </span>
        </a>
      </footer>
    </div>
  );
}
