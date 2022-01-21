
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

- Deploy contracts (on rinkeby network, need some eth):
	- ``npx hardhat run deploy/Deploy.js --network rinkeby ``

- Move json file from artifact to abi-contract file.

- In App.js:
	- Replace SwapADDRESS by Buy contract.
	- Replace TetherADDRESS, KEEYADDRESS by USDT, KEEY address from deploy contract.

- Start frontend
- Public Host: http://sell-keey.s3-website-ap-southeast-1.amazonaws.com/ 