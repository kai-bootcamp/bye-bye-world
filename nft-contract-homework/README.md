# Basic Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```

npx hardhat compile
npx hardhat --network ropsten run scripts/pet-script.js

//verify
npx hardhat verify  --network ropsten 0x5B5021A27E833E889a8effAbE8Ff147010Eceb2F --constructor-args arguments.js --contract contracts/PetNFT.sol:PetNFT


address: https://ropsten.etherscan.io/address/0x4D7cbc68367717490a7eAc7Aa444e09e42b85921#code