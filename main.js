var provider, ERC721abi, contract;

async function onLoad() {
    provider = new ethers.providers.Web3Provider(window.ethereum);
    let response = await fetch("./ERC721_Token.abi.json");
    ERC721abi = await response.json();
}

function loadContract() {
    let address = document.querySelector("#contract-hash").value;
    contract = new ethers.Contract(address, ERC721abi, provider);
    document.querySelector("#tokenID").value = 0;
    displayNFT();
}

async function displayNFT() {
    let img = document.querySelector("#token-image");
    if (img.src != "resources/empty.png")
        URL.revokeObjectURL(img.src);
    
    let id = document.querySelector("#tokenID").value;
    let tokenId = await contract.tokenByIndex(id);
    let uri = await contract.tokenURI(tokenId);
    let json = await getJson(uri);
    // load image
    let imageUri = json.image;
    let blob = await getImage(imageUri);
    img.src = URL.createObjectURL(blob);
    // load attributes
    let attrs = json.attributes;
    let list = document.querySelector("#token-attributes");
    list.innerHTML = "";
    attrs.forEach(attr => {
        let li = document.createElement("li");
        li.appendChild(document.createTextNode(`${attr.trait_type}: ${attr.value}`));
        list.append(li);
    });
}

async function decrementTokenID() {
    let n = await contract.totalSupply();
    if (n == 1) return;
    
    let _id = document.querySelector("#tokenID");
    _id.value--;
    if (_id.value < 0)
        _id.value = n - 1;
    
    displayNFT();
}

async function incrementTokenID() {
    let n = await contract.totalSupply();
    if (n == 1) return;
    
    let _id = document.querySelector("#tokenID");
    _id.value++;
    if (_id.value >= n)
        _id.value = 0;
    
    displayNFT();
}