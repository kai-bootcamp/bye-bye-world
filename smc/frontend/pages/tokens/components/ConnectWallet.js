import React from 'react'
import { Button } from '@mui/material'

const ConnectWallet = (props) => {
  const { selectedAddress, setSelectedAddress } = props

  const connectWallet = async () => {
    const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
    const account = accounts[0];
    setSelectedAddress(account);

    window.ethereum.on('accountsChanged', function (accounts) {
      setSelectedAddress(accounts[0]);
      // TODO: Time to reload your interface with accounts[0]!
    });
  }

  return (
    selectedAddress ? 
      <h2>Account: <span>{selectedAddress}</span></h2>
      : <Button onClick={connectWallet} variant="contained">Enable Ethereum</Button>
  )
}

export default ConnectWallet