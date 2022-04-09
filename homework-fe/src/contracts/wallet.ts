import {ethers} from "ethers"
import abi from './abi/pet_abi.json'

const address = "0x48c55ED284ea520141908C4F215f5ce1A9d93688"

export const getMintPets = async () => {
  try{
    const provider = new ethers.providers.JsonRpcProvider("https://eth-ropsten.alchemyapi.io/v2/QMQyOTixhHSVcDpDj0rPXjM2fBgdiYFJ")

    const contract = new ethers.Contract(address, abi, provider)

    const data = await contract.getAllToken()
    return data

  }catch(error){
    console.log(error)
  }
}

