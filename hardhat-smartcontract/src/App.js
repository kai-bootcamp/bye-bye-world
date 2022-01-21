import './App.css';
import Token from "./abi-contracts/Token.json"
import SellKEEYToken from './abi-contracts/SellKEEYToken.json';

import { ethers, BigNumber } from 'ethers';
import { useEffect, useState } from 'react';
const buyTokenADDRESS = '0x60299126e798510Bd36658e0f3754311e9eF2A5B';
const TetherADDRESS = '0xB08c08bA46B2676F4525D93755a74226aBD30791';
const KEEYADDRESS = '0x0D8d76182AE454Ca2B98AC26515d4EB791c4804B';

const decimal = 1000000000000000000;

function App() {
    const [accounts, setAccounts] = useState([]);
    const [buyAmount, setBuyAmount] = useState(0);
    const [selectedAddress, setSelectedAddress] = useState('');
    const [USDTBalance, setUSDTBalance] = useState("0");
    const [KEEYBalance, setKEEYBalance] = useState("0");
    const [USDTNeeded, setUSDTNeeded] = useState("0");
    const [newBalance, setNewBalance] = useState(0);

    const [usdtContract, setUsdtContract] = useState();
    const [keeyContract, setKeeyContract] = useState();
    async function getContract(){
      if (window.ethereum){
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        // console.log(signer);
        const contractUSDT = new ethers.Contract(
          TetherADDRESS,
          Token.abi,
          signer
        );
        setUsdtContract(contractUSDT);
        const contractKEEY = new ethers.Contract(
          KEEYADDRESS,
          Token.abi,
          signer
        );
        setKeeyContract(contractKEEY);
      }
    }

    async function updateBalanceToken(){
      try{
        var responseUSDT = await usdtContract.balanceOf(selectedAddress); 
        setUSDTBalance(responseUSDT.toString());         
        console.log("USDT: ", responseUSDT.toString());

        var responseKEEY = await keeyContract.balanceOf(selectedAddress); 
        setKEEYBalance(responseKEEY.toString());     
        console.log("KEEY: ", responseKEEY.toString());
      }
      catch(err){
        console.log("error: ", err);
      }
    }
    /*Connect to your account*/

    // A Web3Provider wraps a standard Web3 provider, which is
    // what MetaMask injects as window.ethereum into each page
    // const provider = new ethers.providers.Web3Provider(window.ethereum)
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
      getContract();
      ConnectAccounts();  
    }, []);
    useEffect(() => {
      updateBalanceToken();
    }, [selectedAddress]);
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
          // console.log("Block ID:", await provider.getBlockNumber());
          // console.log("response: ", response);
        }
        catch(err){
          console.log("error: ", err);
          return;
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
        const updateBalance = 1 - newBalance;
        setNewBalance(updateBalance);
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
        <p id = "paragraph">
          Số USDT cần trả: {USDTNeeded}  
        </p>
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
        <div id = "address"> Information</div>
        <div>This is Buy Address Contract: {buyTokenADDRESS}</div>
        <div>This is USDT contract: {TetherADDRESS}</div>
        <p id ="paragraph">Your USDT: {USDTBalance}</p>
        {/* <p><button id='button' onClick={updateBalanceToken}> Your USDT: </button> {USDTBalance}</p> */}
        <div>This is KEEY contract: {KEEYADDRESS}</div>
        <p id = "paragraph">Your KEEY: {KEEYBalance}</p>
        <div> <button id='button' onClick={updateBalanceToken}> Get Balance </button></div>
        </div>
      </center>
    </div>
  );
}

export default App;
