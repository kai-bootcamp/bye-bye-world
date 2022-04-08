const { ethers } = require("hardhat");



async function main() {
  const Array = await ethers.getContractFactory("contracts/utils/Array.sol:Array")

  const array = await Array.deploy()
  await array.deployed()
  const PetNFT = await ethers.getContractFactory('PetNFT', {libraries: {Array: array.address}})
  // Start deployment, returning a promise that resolves to a contract object
  const petNFT = await PetNFT.deploy("PET SHOP", "PET")
  await petNFT.deployed()
  console.log("Contract deployed to address:" , petNFT.address)
}

main().then(() => process.exit(0))
  .catch((error) => {
    console.log(error)
    process.exit(0)
  })