import {
  Box, TextField, Select, FormControl,
  InputLabel, NativeSelect, MenuItem,
  Stack, Grid, Button, InputBase
} from "@mui/material"
import { useState, useEffect, ChangeEvent } from "react"
import { SelectChangeEvent } from '@mui/material/Select'
import * as React from 'react'
import { makeStyles } from "@mui/styles"

import { ethers } from "ethers"
import { MetaMaskInpageProvider } from '@metamask/providers'
import swap_abi from '../../contracts/abi/swap_abi.json'
import key_abi from '../../contracts/abi/keey_abi.json'
import usdt_abi from '../../contracts/abi/usdt_abi.json'

declare let window: any
const { BigNumber } = ethers
const ratio = 10

const contractSwapAddress = "0x79D781883EA7E8216Df5A6a256Eb147F51aEDc50"
const contractKEEYAddress = "0x61FE978c6926eB8e82bd47e95A88BB5C3Ad79E6d"
const contractUSDTAddress = "0x337610d27c682E347C9cD60BD4b3b107C9d34dDd"



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


const useStyles = makeStyles(() => ({
  inputBase: {
    border: "0px !important",
    padding: "16px",
    fontSize: "20px",

  },
  select: {
    minWidth: "130px !important",
    border: "none !important",
    outline: "none !important",
    marginRight: "20px",
    backgroundColor: "rgb(240, 240, 240)",
    borderRadius: "5px"
  },
  approveButton: {
    minWidth: "110px",
    marginLeft: "10px"
  },
  swapButton: {
    minWidth: "110px",
    marginLeft: "10px"
  }

}))

const Convert = () => {
  const classes = useStyles()

  const [convertReferTokenToBaseToken, setConvertingReferToBaseToken] = useState(true)
  const [contractAssetAddress, setContractAssetAddress] = useState(contractUSDTAddress)

  const [value, setValue] = useState(0.0)
  const [referValue, setReferValue] = useState(ratio * value)
  const [isApprove, setApprove] = useState(true)


  useEffect(() => {
    console.log('convertRefer', convertReferTokenToBaseToken)
    console.log('contractAssetAddress', contractAssetAddress)
  }, [convertReferTokenToBaseToken, contractAssetAddress])

  return (
    <Box>
      <Box display="flex" justifyContent={"center"}
        alignItems="center"
        marginTop={"10px"}>
        <Button onClick={connect}>Connect</Button>
      </Box>

      <Box
        display="flex" justifyContent={"center"}
        alignItems="center"
        marginTop={"120px"}
      >
        <Box marginTop={3} maxWidth={"600px"}
          width={"50%"} alignItems={"center"}
          bgcolor="rgb(240, 240, 240)"
          borderRadius={5}
          padding="20px"
          justifyContent={"center"}

        >

          <Box
            display={"flex"}
            justifyContent="space-between"
            alignItems={"center"}
            border="rgb(180, 180, 180) 2px solid" borderRadius={2}
            bgcolor={"white"}
            height='80px'
          //  padding={"10px"} alignItems={"center"}
          >
            <InputBase fullWidth

              className={classes.inputBase}
              type={"number"}
              id="filled-basic"
              onChange={(event: ChangeEvent<HTMLInputElement>) => {
                setValue(parseFloat(event.target.value))

                if (convertReferTokenToBaseToken) {
                  setReferValue(ratio * parseFloat(event.target.value))
                } else (
                  setReferValue(parseFloat(event.target.value) / ratio)
                )

                console.log({ value })
              }}
              value={value}
            />

            <FormControl
              className={classes.select}
            >
              <InputLabel id="demo-simple-select-label"

              >Asset</InputLabel>

              <Select
                labelId="demo-simple-select-label"
                id="demo-simple-select"
                value={convertReferTokenToBaseToken ? "USDT" : "KEEYS"}
                label="Age"
                onChange={(event: SelectChangeEvent) => {
                  if (event.target.value as string === "KEEYS") {
                    setContractAssetAddress(contractKEEYAddress)
                    setConvertingReferToBaseToken(false)
                    setReferValue(value / ratio)


                  } else {
                    setContractAssetAddress(contractUSDTAddress)
                    setConvertingReferToBaseToken(true)
                    setReferValue(value * ratio)
                  }
                }}
              >
                <MenuItem value={"USDT"}>USDT</MenuItem>
                <MenuItem value={"KEEYS"}>KEEYS</MenuItem>
              </Select>

            </FormControl>

          </Box>

          <Box
            margin="10px 0px 10px 0px"
            border="rgb(180, 180, 180) 2px solid"
            bgcolor="white"
            height="80px"
            justifyContent={"space-between"}
            display="flex" borderRadius={2}
            alignItems={"center"}
          >

            <InputBase
              className={classes.inputBase}
              type={"number"}
              id="filled-base"
              value={referValue}
              disabled={true}
            />

            <FormControl className={classes.select}
            >
              <InputLabel id="demo-simple-base-select" >Asset </InputLabel>

              <Select
                labelId="demo-simple-base-select"
                id="demo-simple-base"
                value={!convertReferTokenToBaseToken ? "USDT" : "KEEYS"}
                label="Age"
                disabled={true}
              >
                <MenuItem value={"USDT"}>USDT</MenuItem>
                <MenuItem value={"KEEYS"}>KEEYS</MenuItem>
              </Select>

            </FormControl>
          </Box>




          <Box display={'flex'} alignItems="center" justifyContent="center" >
            <Button variant="contained" className={classes.approveButton} onClick={() => {
              convertReferTokenToBaseToken ? approveUsdtTransfer() : approveKeeyTransfer()
              setApprove(false)
            }}>
              Approve
            </Button>
            <Button variant="contained" className={classes.swapButton} onClick={() => {
              convertReferTokenToBaseToken ? convertUsdtToKeey() : convertKeeyToUsdt()
              setApprove(true)
            }}>
              Swap
            </Button>
          </Box>

        </Box>
      </Box>
    </Box>


  )
}

export default Convert