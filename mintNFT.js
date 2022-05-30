var init = false;
var provider, signer, account, contract;

async function initialize() {
    provider = new ethers.providers.Web3Provider(window.ethereum);
    await provider.send('eth_requestAccounts', []);
    signer = await provider.getSigner();
    account = await signer.getAddress();
    
    const response = await fetch("./ERC721_Token.abi.json");
    const contract_abi = await response.json();
    const contract_address = "0x2B3210F5fd805f17E6F20B4052eAe6A9fD24E734";
    contract = new ethers.Contract(contract_address, contract_abi, signer);
}

async function mintNFT() {
    if (!init) {
        await initialize();
        init = true;
    }
    const url = `ipfs://${jsonHash}`;
    console.log(`tokenURL: ${url}`);
    contract.mint(account, url).then(response => {
        console.log("Transaction pending...");
        return response.wait(5);
    }).then(receipt => {
        console.log("Transaction successful.");
        console.log(receipt);
    }).catch(error => {
        console.log(error);
    });;
}
