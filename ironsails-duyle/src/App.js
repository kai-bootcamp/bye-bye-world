// import { ethers } from 'ethers';
// import properties from './constants.properties';
// import LADToken from './artifacts/contracts/LADToken.sol/LADToken.json';
// import SellTokenContract from './artifacts/contracts/SellToken.sol/SellToken.json';

// const LADTokenAddress = "0xb7E13cE03319559EC7bc41C0202E17875b82f222";
// const SellTokenAddress = "0xB5a617F46df25F1ea728e57692E50F99372315ca";
// const LADTokenAddress = properties.LADTokenAddress;
// const SellTokenAddress = properties.SellTokenAddress;
import './App.css';
import React, { useEffect, useState } from 'react';
import { init, getBalanceOf, getAllowance, buyToken } from './Web3Client';
import { hexValue } from '@ethersproject/bytes';

function App() {

  useEffect(() => {
    init();
  }, []);

  const [balance, setBalance] = useState(0);
  // const [allowance, setAllowance] = useState(0);
  const [buy, setBuy] = useState(0);

  const fetchBalance = () => {
    getBalanceOf().then(balance => {
      setBalance(balance);
    }).catch(err => {
      console.log(err);
    })
  };

  const buyLADToken = async (amount) => {
    console.log("Start buying");
    buyToken(amount).then(buy => {
      setBuy(buy);
    }).catch(err => {
      console.log(err);
    });
    console.log("Finish buying");
  };


  return (
    <div className="App">
      <header className="App-header">

        <p>Your balance is {balance}</p>
        
        <button onClick={() => fetchBalance()}>Refresh balance</button>
        <br/>

        <h2>Buy Token</h2>
        {/* <input onChange={e => buyLADToken(e.target.value)} placeholder="Number Of Token" /> */}
        <input id="ladinput" placeholder="Number Of Token" />
      
        
        <button onClick={e => buyLADToken(document.querySelector('#ladinput').value)}>BUY LAD</button>
      </header>
    </div>
  );
}

export default App;