import { Grid, Box, Typography, Button } from "@mui/material"
import { ethers } from "ethers"

import { MetaMaskInpageProvider } from '@metamask/providers'
import swap_abi from '../contracts/abi/swap_abi.json'
import key_abi from '../contracts/abi/keey_abi.json'
import usdt_abi from '../contracts/abi/usdt_abi.json'

const contractSwapAddress = "0x79D781883EA7E8216Df5A6a256Eb147F51aEDc50"
const contractKEEYAddress = "0x61FE978c6926eB8e82bd47e95A88BB5C3Ad79E6d"
const contractUSDTAddress = "0x337610d27c682E347C9cD60BD4b3b107C9d34dDd"
declare let window: any
const { BigNumber } = ethers


const connect = async () => {
  if (typeof window.ethereum !== "undefined") {

    const ethereum = window.ethereum as MetaMaskInpageProvider
    console.log("metamask in here")
    await ethereum.request({ method: "eth_requestAccounts" })
  }
}


const approveUsdtTransfer = async () => {
  const provider = new ethers.providers.Web3Provider(window.ethereum)

  const signer = provider.getSigner()
  const contract = new ethers.Contract(contractUSDTAddress, usdt_abi, signer)
  await contract.approve(contractSwapAddress, BigNumber.from('10000000000000000'))


}

const convertUsdtToKeey = async () => {
  try {
    const provider = new ethers.providers.Web3Provider(window.ethereum)

    const signer = provider.getSigner()
    const contract = new ethers.Contract(contractSwapAddress, swap_abi, signer)
    await contract.swap(BigNumber.from('10000000000000000'), true)
  } catch (error) {
    console.log(error)
  }

}

const approveKeeyTransfer = async () => {
  try {
    const provider = new ethers.providers.Web3Provider(window.ethereum)

    const signer = provider.getSigner()
    const contract = new ethers.Contract(contractKEEYAddress, key_abi, signer)
    await contract.approve(contractSwapAddress, BigNumber.from('1000000000000000000'))
  } catch (error) {
    console.log(error)
  }

}

const convertKeeyToUsdt = async () => {
  try {
    const provider = new ethers.providers.Web3Provider(window.ethereum)
    const signer = provider.getSigner()
    const contract = new ethers.Contract(contractSwapAddress, swap_abi, signer)
    await contract.swap(BigNumber.from('1000000000000000000'), false)
  } catch (error) {
    console.log(error)
  }
}


const Swap = () => {
  return (
    <Box>
      <Button onClick={connect}>Connect</Button>

      <Button onClick={approveUsdtTransfer}>Approve USDT Transfer</Button>
      <Button onClick={convertUsdtToKeey}>Convert USDT To Keey</Button>


      <Button onClick={approveKeeyTransfer}>Approve KEEY Transfer</Button>
      <Button onClick={convertKeeyToUsdt}>convert KEEY to USDT</Button>

    </Box>
  )
}

export default Swap;