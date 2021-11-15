import Web3 from 'web3';
import BigNumber from "bignumber.js";

import LADToken from './artifacts/contracts/LADToken.sol/LADToken.json';
import SellTokenContract from './artifacts/contracts/SellToken.sol/SellTokenContract.json';
import USDTTokenContract from './USDTToken.json';


let selectedAccount;
let isInitialized = false;
let ladTokenContract;
let sellTokenContract;
let usdtTokenContract;
const SellTokenContractAddress = '0xB5a617F46df25F1ea728e57692E50F99372315ca';
const ownerLAD = '0x1D3501C5dfe6D132f94a42b1304c2f1eE9F0871e';
const PRIVATE_KEY = '03b2d223132d73ffffa41dbcec7a2357d4df6e0404c2e02194d9f6c59d44c8c9';

let isLADApproved = false;

export const init = async () => {

    // Check if metamask is installed
    const providerUrl = "https://rinkeby.infura.io/v3/10e84f3a2f1f4d5db6fbd2520fd35853";
    let provider = window.ethereum;

    console.log('Started connecting...')
    // provider !== 'undefined' ---> Metamask is installed!
    if (typeof provider !== 'undefined') {

        console.log('Metamask is connected!')
        await provider
            .request({ method: 'eth_requestAccounts' })
            .then((accounts) => {
                selectedAccount = accounts[0];
                console.log(`Selected account is ${selectedAccount}`);
            })
            .catch((err) => {
                console.log(err);
            });

        // Metamask listen for changing in account
        window.ethereum.on('accountsChanged', function (accounts) {
            selectedAccount = accounts[0];
            console.log(`Selected account is changed to ${selectedAccount}`);
        });
    };

    console.log('Finished connecting...')

    const web3 = new Web3(provider);

    // Adding smart contract using ABI
    ladTokenContract = new web3.eth.Contract(
        LADToken.abi,
        // Contract address on Rinkeby Testnet
        '0xb7E13cE03319559EC7bc41C0202E17875b82f222'
    );

    sellTokenContract = new web3.eth.Contract(
        SellTokenContract.abi,
        // Contract address on Rinkeby Testnet
        '0xB5a617F46df25F1ea728e57692E50F99372315ca'
    );

    usdtTokenContract = new web3.eth.Contract(
        USDTTokenContract.abi,
        '0x5074EB29a56b4c2bE687BE27c242BcBb8aA1224c'
    );

    if (!isLADApproved) {
        isLADApproved = ladTokenContract.methods.approve(SellTokenContractAddress, 1234).send({ from: '0x1D3501C5dfe6D132f94a42b1304c2f1eE9F0871e' });
    }

    isInitialized = true;
};


export const buyToken = async (amount) => {
    if (!isInitialized) {
        await init();
    }

    console.log('Inside buy token function');
    console.log(`Selected Account is: ${selectedAccount}`);

    // Approve USDT
    let approvedUSDTAmmount = await getUSDTAllowance(selectedAccount);
    if (approvedUSDTAmmount === 0) {
        await usdtTokenContract.methods.approve(SellTokenContractAddress, "1000000000000").send({ from: selectedAccount });
    };

    // Buy Token
    await sellTokenContract.methods.buy(amount).send({ from: selectedAccount });
};

export const getBalanceOf = async () => {

    if (!isInitialized) {
        await init();
    }

    return ladTokenContract.methods
        .balanceOf(selectedAccount)
        .call();
};

export const getAllowance = async () => {
    if (!isInitialized) {
        await init();
    };

    return ladTokenContract.methods.allowance(ownerLAD, SellTokenContractAddress).call();
};

export const getUSDTAllowance = async (userAddress) => {
    if (!isInitialized) {
        await init();
    };

    return usdtTokenContract.methods.allowance(userAddress, SellTokenContractAddress).call();
};