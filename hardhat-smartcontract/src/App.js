import './App.css';
import KEEYToken from './abi-contracts/KEEYToken.json';
import Tether from './abi-contracts/Tether.json';
import TokenSwap from './abi-contracts/TokenSwap.json';

import { ethers, BigNumber } from 'ethers';
import { useEffect, useState } from 'react';
const SwapADDRESS = '0x5b1dC88F4660053C4b6C984c15993BA1119D54dB';
const TetherADDRESS = '0x2483b7C0778cFb8f870b57019a22764d46D126C4';
const KEEYADDRESS = '0x31aA7a40eC0B37FfdcAf154C4db71A48eF8B5836';
const decimal = 1000000000000000000;

function App() {
    /*Connect to your account*/

    // A Web3Provider wraps a standard Web3 provider, which is
    // what MetaMask injects as window.ethereum into each page
    // const provider = new ethers.providers.Web3Provider(window.ethereum)
    const [accounts, setAccounts] = useState([]);
    const [buyAmount, setBuyAmount] = useState(0);
    const [selectedAddress, setSelectedAddress] = useState('');
    const [USDTBalance, setUSDTBalance] = useState("0");
    const [KEEYBalance, setKEEYBalance] = useState("0");
    const [USDTNeeded, setUSDTNeeded] = useState("0");
 
    //Metamask can return multiple accounts, so we'll use the first one
    async function ConnectAccounts(){
      if (window.ethereum) {
        
        const accounts = await window.ethereum.request({
          method: 'eth_requestAccounts'
        });
        setAccounts(accounts);
        setSelectedAddress(window.ethereum.selectedAddress);
        window.ethereum.on('accountsChanged', function (accounts) {
          setSelectedAddress(accounts[0]);
          setAccounts(accounts);
          setUSDTBalance(0);
          setKEEYBalance(0);
          // TODO: Time to reload your interface with accounts[0]!
        });
      }
    }


    useEffect(() => {
      ConnectAccounts();
    }, []);
    /*Buy KEEY*/
    async function handleBuy(){
      if (window.ethereum){
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        console.log(signer);
        const contract = new ethers.Contract(
          SwapADDRESS,
          TokenSwap.abi,
          // TetherADDRESS,
          // Tether.abi,
          signer
        );
        try{
          // const response = await contract.balanceOf(selectedAddress);
          const response = await contract.buyKEEY(ethers.utils.parseUnits(buyAmount.toString(), 18));
          
          console.log("Block ID:", await provider.getBlockNumber());
          console.log("USDT: ", response.toString());
        }
        catch(err){
          console.log("error: ", err);
        }
      }
    }
  
    async function handleUSDT(){
      if (window.ethereum){
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        console.log(signer);
        const contract = new ethers.Contract(
          // SwapADDRESS,
          // TokenSwap.abi,
          TetherADDRESS,
          Tether.abi,
          signer
        );
        try{
          const response = await contract.balanceOf(selectedAddress); 
          setUSDTBalance(response.toString());         
          console.log("Block ID:", await provider.getBlockNumber());
          console.log("USDT: ", response.toString());
        }
        catch(err){
          console.log("error: ", err);
        }
      }
    }

    async function handleKEEY(){
      if (window.ethereum){
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        console.log(signer);
        const contract = new ethers.Contract(
          // SwapADDRESS,
          // TokenSwap.abi,
          KEEYADDRESS,
          KEEYToken.abi,
          signer
        );
        try{
          const response = await contract.balanceOf(selectedAddress); 
          setKEEYBalance(response.toString());         
          console.log("Block ID:", await provider.getBlockNumber());
          console.log("KEEY: ", response.toString());
        }
        catch(err){
          console.log("error: ", err);
        }
      }
    }

    async function handleAmount(e){
      setBuyAmount(e.target.value);
      setUSDTNeeded(e.target.value * 10000);
      // console.log(buyAmount);
  }
  return (
    <div className="App">
      <center className ="border">
        <div className="sidepanel">
        
        <p>This is your Address: <a href={`https://rinkeby.etherscan.io/address/${selectedAddress}`}>{selectedAddress}</a></p>
        <button id='button' onClick={() => handleBuy()}>
              Số USDT cần trả: {USDTNeeded}  
            </button>
        {accounts.length && (
          <div>
            <button id='button' onClick={() => handleBuy()}>
              Buy KEEY  
            </button>
             &nbsp;&nbsp;
            <input
                id='input'
                type="text"
                placeholder='Nhập số KEEY(10000USDT / KEEY)'
                onChange={(e) => handleAmount(e)}
            >
            </input> 
            
          </div>
        )}
        <div> FOR TESTING</div>
        <div>This is Buy Address Contract: {SwapADDRESS}</div>
        <div>This is USDT contract: {TetherADDRESS}</div>

        <p><button id='button' onClick={handleUSDT}>Balance Your USDT: </button> {USDTBalance}</p>
        <div>This is KEEY contract: {KEEYADDRESS}</div>
        <div> <button id='button' onClick={handleKEEY}>Balance Your KEEY: </button> {KEEYBalance}</div>
        </div>
      </center>
    </div>
  );
}

export default App;
