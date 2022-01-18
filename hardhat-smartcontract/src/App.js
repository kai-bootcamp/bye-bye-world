import './App.css';
import Token from "./abi-contracts/Token.json"
import SellKEEYToken from './abi-contracts/SellKEEYToken.json';

import { ethers, BigNumber } from 'ethers';
import { useEffect, useState } from 'react';
const buyTokenADDRESS = '0x7EB92111aE413720e45f981cd1013305155C3E8C';
const TetherADDRESS = '0x856d3BFE31e6E689d80A1deFe1b6592Cb76F0a44';
const KEEYADDRESS = '0x4E2BEfF136AF63139203bd2593b6699Db3F4D21A';

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
    const [newBalance, setNewBalance] = useState(0);
    async function balanceUSDT(){
      if (window.ethereum){
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        // console.log(signer);
        const contract = new ethers.Contract(
          // SwapADDRESS,
          // TokenSwap.abi,
          TetherADDRESS,
          Token.abi,
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

    async function balanceKEEY(){
      if (window.ethereum){
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        // console.log(signer);
        const contract = new ethers.Contract(
          // SwapADDRESS,
          // TokenSwap.abi,
          KEEYADDRESS,
          Token.abi,
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
          // TODO: Time to reload your interface with accounts[0]!
        });
      }
    }


    useEffect(() => {
     ConnectAccounts();  
    }, []);
    useEffect(() => {
      balanceKEEY();
      balanceUSDT();
    }, [selectedAddress, newBalance]);
    /*Buy KEEY*/
    async function handleBuy(){
      if (window.ethereum){
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        // console.log(signer);
        //Approve
        const userContract = new ethers.Contract(
          TetherADDRESS,
          Token.abi,
          // TetherADDRESS,
          // Tether.abi,
          signer
        );

        try{
          const response = await userContract.approve(buyTokenADDRESS, USDTBalance);
          console.log("allowance: ", await userContract.allowance(selectedAddress, buyTokenADDRESS));
          console.log("Block ID:", await provider.getBlockNumber());
          
        }
        catch(err){
          console.log("error: ", err);
        }


        //Buy
        const buyContract = new ethers.Contract(
          buyTokenADDRESS,
          SellKEEYToken.abi,
          signer
        );

        const keeyContract = new ethers.Contract(
          KEEYADDRESS,
          Token.abi,
          signer
        );
        try{
          // const response = await contract.balanceOf(selectedAddress);
          
          
          console.log("USDT allowance: ", await userContract.allowance(selectedAddress, buyTokenADDRESS));
          console.log("Block ID:", await provider.getBlockNumber());
          
          const response = await buyContract.buyKEEY(buyAmount);
          console.log(response);
        }
        catch(err){
          console.log("error: ", err);
        }
        const updateBalace = 1 - newBalance;
        setNewBalance(updateBalace);
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
        
        <p>This is your Address: <a id = "address" href={`https://rinkeby.etherscan.io/address/${selectedAddress}`}>{selectedAddress}</a></p>
        <button id='button'>
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
        <div>This is Buy Address Contract: {buyTokenADDRESS}</div>
        <div>This is USDT contract: {TetherADDRESS}</div>

        <p><button id='button' onClick={balanceUSDT}>Balance Your USDT: </button> {USDTBalance}</p>
        <div>This is KEEY contract: {KEEYADDRESS}</div>
        <div> <button id='button' onClick={balanceKEEY}>Balance Your KEEY: </button> {KEEYBalance}</div>
        </div>
      </center>
    </div>
  );
}

export default App;
