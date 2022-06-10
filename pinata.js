const gateway = "https://gateway.pinata.cloud/ipfs/";

async function getJson(ipfsUri) {
    let ipfsHash = ipfsUri.split("ipfs://")[1];
    let url = gateway + ipfsHash;
    let response = await fetch(url);
    if (response.status == 200) {
        return response.json();
    } else {
        console.log(response);
    }
}

async function getImage(ipfsUri) {
    let ipfsHash = ipfsUri.split("ipfs://")[1];
    let url = gateway + ipfsHash;
    let response = await fetch(url);
    if (response.status == 200) {
        return response.blob();
    } else {
        console.log(response);
    }
}