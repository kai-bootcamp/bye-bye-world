import Head from "next/head";
import Image from "next/image";
import { load, loadContract, loadInfoAccount } from "../lib/utils";
import styles from "../styles/Home.module.css";
import React, { useState, useEffect } from "react";
import { ethers } from "ethers";
import { DECIMALS, RATE, SELLER_ADDRESS, TOTAL_KEEY_SALE } from "../lib/contants";


export default function Home() {
  const [contractKeey, setContractKeey] = useState(null);
  const [contractKTS, setContractKTS] = useState(null);
  const [contractUSDT, setContractUSDT] = useState(null);
  const [account, setAccount] = useState(null);
  const [fundsUSDT, setFundsUSDT] = useState(-1);
  const [myKeey, setMyKeey] = useState(-1);
  const [transactionCount, setTransactionCount] = useState(-1);
  const [transactions, setTransactions] = useState(undefined);
  const [value, setValue] = useState(0);
  const [balanceKeeyOfSale, setBalanceKeeyOfSale] = useState(-1);
  const [waiting, setWaiting] = useState(false);

  const handleInput = (e) => {
    setValue(e.currentTarget.value);
  };

  const isLoading = () => {
    return (
      account == null || contractKeey == null || contractKTS == null || contractUSDT == null ||
      fundsUSDT < 0 ||
      myKeey < 0 ||
      transactions === undefined ||
      transactionCount == -1 ||
      balanceKeeyOfSale < 0
    );
  };

  const handleUseEffect = async () => {
    load().then((data) => {
      console.log(data);
      setContractKeey(data.contractKeey);
      setContractKTS(data.contractKTS);
      setContractUSDT(data.contractUSDT);
      setAccount(data.account);
      setFundsUSDT(data.fundsUSDT);
      setMyKeey(data.myKeey);
      setTransactionCount(data.transactionCount);
      setTransactions(data.transactions);
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

    contractKTS.on("Sell", (data) => {
      console.log("Sell success: ", data);
      
      const newFunds = Number(fundsUSDT) + Number(value)*Number(RATE); 
      const newMyKeey = Number(myKeey) + Number(value);
      const newBalance =  balanceKeeyOfSale - value;
      const newTransaction = [{
        buyer: account,
        amount: value
      }, ...transactions];
      
      while(newTransaction.length > 10) {
        newTransaction.pop();
      }
      
      alert("Buy token successfully");
      setWaiting(false);
      setFundsUSDT(newFunds);
      setMyKeey(newMyKeey);
      setBalanceKeeyOfSale(newBalance);
      setTransactions(newTransaction);

    });
  };

  const approveUSDT = async () => {
    const approveAmount = ethers.BigNumber.from(BigInt(DECIMALS)).mul(
      RATE * value
    );
    await contractUSDT.approve(SELLER_ADDRESS, approveAmount, {
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
      alert("Token KEEY was sold all!");
      return;
    }
    setWaiting(true);
    await contractKTS.endSale({
      from: account,
      value: 0,
      gasLimit: 500000,
    });
    contractKTS.on("EndSale", (amount) => {
      const amountNumber = amount/DECIMALS; 
      alert(`Get ${amountNumber} KEEY back to seller address successfully!`);
      setWaiting(false);
      setBalanceKeeyOfSale(0);

      if(account === SELLER_ADDRESS) {
        setMyKeey(myKeey + amountNumber);
      }
    });
  }

  useEffect(() => {
    handleUseEffect();
  }, []);

  return (
    <div className={styles.container}>
      <Head>
        <title>ICO KEEY</title>
        <meta name="description" content="KEEY Token ICO" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>
          Welcome to{" "}
          <a href={`https://kovan.etherscan.io/token/${contractKeey ? contractKeey.address: '0x20efB4D92cAe8FfD89C138Ba54E908B9C6037d49'}`}>
            KEEY
          </a>{" "}
          ICO
        </h1>
        {isLoading() ? (
          <p className={styles.description}>Loading....</p>
        ) : (
          <>
            <p className={styles.description}>
              1 KEEY = {RATE} USDT {"  "}
              {account.toLowerCase() === SELLER_ADDRESS.toLowerCase() && <button className={`${styles.button} ${styles.button_secondary}`} onClick={handleEndSale}>End Sale</button>}
            </p>
            <div className={styles.progress_wrapper}>
              <p className={styles.progress_content}>
                {TOTAL_KEEY_SALE - balanceKeeyOfSale}/{TOTAL_KEEY_SALE} KEEY
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
                      placeholder="Amount KEEY"
                      className={styles.input}
                      value={value}
                      onChange={handleInput}
                    />
                    <button className={styles.button} onClick={handleBuyToken}>
                      Buy KEEY
                    </button>
                  </div>
                  <p style={{ fontSize: "1rem" }}>My Address: {account}</p>
                </>
              )}
            </div>

            <div className={styles.grid}>
              <div className={styles.card}>
                <h2>Information &rarr;</h2>
                <p>Transactions: {transactionCount}</p>
                <p>Funds: {fundsUSDT} USDT</p>
                <p>My KEEY: {myKeey} KEEY</p>
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
