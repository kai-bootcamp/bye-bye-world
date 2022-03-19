import Head from "next/head";
import Image from "next/image";
import { load, loadInfoAccount } from "../lib/utils";
import styles from "../styles/Home.module.css";
import React, { useState, useEffect } from "react";
import { ethers } from "ethers";
import { DECIMALS, RATE, SELLER_ADDRESS, TOTAL_KEEY_SALE } from "../lib/contants";

export default function Home() {
  const [signer, setSigner] = useState(null);
  const [provider, setProvider] = useState(null);
  const [contractKeey, setContractKeey] = useState(null);
  const [contractKTS, setContractKTS] = useState(null);
  const [contractUSDT, setContractUSDT] = useState(null);
  const [transactionCount, setTransactionCount] = useState(-1);
  const [transactions, setTransactions] = useState(undefined);
  const [balanceKeeyOfSale, setBalanceKeeyOfSale] = useState(-1);
  const [fundsUSDT, setFundsUSDT] = useState(-1);
  const [account, setAccount] = useState(null);
  const [myKeey, setMyKeey] = useState(-1);
  const [value, setValue] = useState(0);
  const [waiting, setWaiting] = useState(false);

  const handleInput = (e) => {
    setValue(e.currentTarget.value);
  };

  const isLoading = () => {
    // account == null || myKeey < 0
    return (
      contractKeey == null || contractKTS == null || contractUSDT == null || provider == null ||
      fundsUSDT < 0 ||
      transactions === undefined ||
      transactionCount == -1 ||
      balanceKeeyOfSale < 0
    );
  };

  const handleUseEffect = async () => {
    load().then((data) => {
      console.log(data);
      setProvider(data.provider);
      setContractKeey(data.contractKeey);
      setContractKTS(data.contractKTS);
      setContractUSDT(data.contractUSDT);
      setFundsUSDT(data.fundsUSDT);
      setTransactionCount(data.transactionCount);
      setTransactions(data.transactions);
      setBalanceKeeyOfSale(data.balanceKeeyOfSale);
    });
  };

  const handleConnectToWallet = async () => {
    await provider.send("eth_requestAccounts", []);
    const signer = provider.getSigner();
    const firstAccount = await signer.getAddress();
    const { account, myKeey } = await loadInfoAccount(firstAccount, contractKeey);
    setSigner(signer);
    setAccount(account);
    setMyKeey(myKeey);

    window.ethereum.on("accountsChanged", async (accounts) => {
      signer = provider.getSigner();
      const { account, myKeey } = await loadInfoAccount(accounts[0], contractKeey);
      setSigner(signer);
      setAccount(account);
      setMyKeey(myKeey);
    });
  };

  const handleBuyToken = async () => {

    if (value <= 0) {
      alert("Value must not less than or equal to 0!");
      setValue(0);
      return;
    }

    if (value > balanceKeeyOfSale) {
      alert("Value must not greater than balance of Keey Seller");
      setValue(0);
      return;
    }
    setWaiting(true);
    await approveUSDT();
    const amountToken = ethers.BigNumber.from(BigInt(DECIMALS)).mul(value);
    const txBuy = await contractKTS.connect(signer).buyToken(amountToken, {
      from: account,
      value: 0,
      gasLimit: 500000,
    });

    txBuy.wait().then( msg => {
      if(msg.confirmations) {
        const newFunds = Number(fundsUSDT) + Number(value)*Number(RATE); 
        const newMyKeey = Number(myKeey) + Number(value);
        const newBalance =  balanceKeeyOfSale - value;
        const newTransactionCount = ++transactionCount;
        const newTransaction = [{
          buyer: account,
          amount: value
        }, ...transactions];
        
        while(newTransaction.length > 10) {
          newTransaction.pop();
        }
        
        alert("Buy token successfully");
        setFundsUSDT(newFunds);
        setMyKeey(newMyKeey);
        setBalanceKeeyOfSale(newBalance);
        setTransactionCount(newTransactionCount);
        setTransactions(newTransaction);
      } else {
        alert("Buy token failed!");
      }
      setValue(0);
      setWaiting(false);
    });
  };

  const approveUSDT = async () => {
    const approveAmount = ethers.BigNumber.from(BigInt(DECIMALS)).mul(
      RATE * value
    );
    await contractUSDT.connect(signer).approve(contractKTS.address, approveAmount, {
      from: account,
      value: 0,
      gasLimit: 500000,
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
    await contractKTS.connect(signer).endSale({
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
              {account && account.toLowerCase() === SELLER_ADDRESS.toLowerCase() && <button className={`${styles.button} ${styles.button_secondary}`} onClick={handleEndSale}>End Sale</button>}
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
                account ? (
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
                ): (
                  <>
                    <button className={`${styles.button} ${styles.button_secondary}`} onClick={handleConnectToWallet}>Connect To Wallet</button>
                  </>
                )
              )}
            </div>

            <div className={styles.grid}>
              <div className={styles.card}>
                <h2>Information &rarr;</h2>
                <p>Transactions: {transactionCount}</p>
                <p>Funds: {fundsUSDT} USDT</p>
                {myKeey >= 0 && <p>My KEEY: {myKeey} KEEY</p>}
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
