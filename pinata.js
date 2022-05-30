const pinataJWT = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySW5mb3JtYXRpb24iOnsiaWQiOiJjZWU2MTkxNi03NTNhLTRiYmItYjI1OC0zZWQ0NjE0MTg3NzEiLCJlbWFpbCI6ImlvaGt5dXFlbEBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicGluX3BvbGljeSI6eyJyZWdpb25zIjpbeyJpZCI6IkZSQTEiLCJkZXNpcmVkUmVwbGljYXRpb25Db3VudCI6MX1dLCJ2ZXJzaW9uIjoxfSwibWZhX2VuYWJsZWQiOmZhbHNlfSwiYXV0aGVudGljYXRpb25UeXBlIjoic2NvcGVkS2V5Iiwic2NvcGVkS2V5S2V5IjoiMWU3NGE0ZDExZmQxOWYzZmRhNTUiLCJzY29wZWRLZXlTZWNyZXQiOiIyMTg2ZDU1MjYyNmIzYWEzNTY1MGEzNmE2MmUzZjYwYWE4Mjc5YTIwNTRjOTZmNWQ1MjdmYjVkZmE1YjY3YmI0IiwiaWF0IjoxNjUzODk4MjE3fQ.TrmIiklRdw9BlGDvsUVSbW3vbvolW6CFPsdzpKfUR70"
const pinataBaseURL = "https://api.pinata.cloud"
var imageHash, jsonHash;

function checkFormData() {
    return true;
    // TODO implement check
}

async function pinToPinata() {
    if (!checkFormData())
        return;
    let files = document.querySelector("#image").files;
    if (files.length == 0) {
        alert("No file selected.");
        return;
    }
    await pinFile(files[0]);
    let json = makeJSON();
    await pinJSON(json);
}

async function pinFile(file) {
    let x = new FormData();
    x.append("file", file);
    
    const endpointURL = "/pinning/pinFileToIPFS";
    let response = await fetch(pinataBaseURL + endpointURL, {
        method: "POST",
        headers: {
            "Authorization": `Bearer ${pinataJWT}`
        },
        body: x
    });
    let json = await response.json();
    imageHash = json["IpfsHash"];
    console.log(`image pinned with hash: ${imageHash}`);
}

function makeJSON() {
    let object = {
        name: `${document.querySelector("#name").value}`,
        description: "",
        image: `ipfs://${imageHash}`,
        attributes: [{
            trait_type: "Level",
            value: `${document.querySelector("#level").value}`
        },{
            trait_type: "Attribute",
            value: `${document.querySelector("#attribute").value}`
        },{
            trait_type: "Tribe",
            value: `${document.querySelector("#tribe").value}`
        }]
    };
    return JSON.stringify(object);
}

async function pinJSON(data) {
    const endpointURL = "/pinning/pinJSONToIPFS";
    let response = await fetch(pinataBaseURL + endpointURL, {
        method: "POST",
        headers: {
            "Authorization": `Bearer ${pinataJWT}`,
            "Content-Type": "application/json"
        },
        body: data
    });
    let json = await response.json();
    jsonHash = json["IpfsHash"];
    console.log(`JSON pinned with hash: ${jsonHash}`);
}