import Head from 'next/head'
import Image from 'next/image'
import { load } from '../lib/utils';
import styles from '../styles/Home.module.css'
import React, {useState, useEffect} from 'react';

export default function Home() {
  const [refresh, setRefresh] = useState(false);
  const [account, setAccount] = useState(null);
  const [contractKeey, setContractKeey] = useState(null);
  const [contractKTS, setContractKTS] = useState(null);
  const [contractUSDT, setContractUSDT] = useState(null);
  const [rate, setRate] = useState(0);
  const [fundsUSDT, setFundsUSDT] = useState(-1);
  const [myKeey, setMyKeey] = useState(-1);
  const [transactions, setTransactions] = useState(undefined);

  const isLoading = () => {
    return account == null || contractKTS == null 
    || contractKeey == null || contractUSDT == null || rate == 0 || fundsUSDT < 0
    || myKeey < 0 || transactions == undefined;
  }

  const handleUseEffect = async () => {
    if(refresh) return;
    setRefresh(true);
    load().then((data) => {
      console.log("FUNDS Page: ", process.env.FUNDS_ADDRESS);
      console.log(data);
      setAccount(data.account);
      setContractKTS(data.contractKTS);
      setContractKeey(data.contractKeey);
      setContractUSDT(data.contractUSDT);
      setRate(data.rate);
      setFundsUSDT(data.fundsUSDT);
      setMyKeey(data.myKeey);
      setTransactions(data.transactions);
    })
  };

  const handleBuyToken = async () => {
    await approveUSDT();
    const amountToken = BigInt(2 * 10**18);
    await contractKTS.buyToken(amountToken, {
      from: account,
      value: 0,
      gasLimit: 500000
    });
    alert("Buy token successfully");
    setRefresh(false);
  }

  const approveUSDT = async () => {
    await contractUSDT.approve('0x74756DAc944FD192Bb85a8A613918e107e3dcc85', BigInt(rate*2*10**18), {
      from: account,
      value: 0,
      gasLimit: 500000
    });
  }

  useEffect(() => {
    handleUseEffect();
  });
  
  return (
    <div className={styles.container}>
      <Head>
        <title>Keey Token ICO</title>
        <meta name="description" content="Keey Token ICO" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>
          Welcome to <a href="https://kovan.etherscan.io/token/0xe755a2048fb976fa58a668d6f0dc23b5b38a9e08">Keey</a> ICO
        </h1>
        {
          isLoading() ? <p className={styles.description}>
            Loading....
          </p> : (
            <>
              <p className={styles.description}>
                1 Keey = {rate} USDT {'  '}
                <button className={styles.button} onClick={handleBuyToken}>Buy Keey</button>
                {/* <code className={styles.code}>pages/index.js</code> */}
              </p>
      
              <div className={styles.grid}>
                <div className={styles.card}>
                  <h2>Information &rarr;</h2>
                  <p>Transactions: 5</p>
                  <p>Funds: {fundsUSDT} USDT</p>
                  <p>My Address: {account}</p>
                  <p>My Keey: {myKeey} KEEY</p>
                </div>
      
                {/* <div className={styles.card}>
                  <h2>Last 10 transactions &rarr;</h2>

                  {transactions.map(transaction => {
                    <div>
                      <p>{transaction.buyer}</p>
                      <p>{transaction.amount}</p>
                    </div>
                  })}
                </div> */}
              </div>
            </>
          )
        }
      </main>

      <footer className={styles.footer}>
        <a
          href="https://vercel.com?utm_source=create-next-app&utm_medium=default-template&utm_campaign=create-next-app"
          target="_blank"
          rel="noopener noreferrer"
        >
          Powered by{' '}
          <span className={styles.logo}>
            <Image src="/vercel.svg" alt="Vercel Logo" width={72} height={16} />
          </span>
        </a>
      </footer>
    </div>
  )
}
