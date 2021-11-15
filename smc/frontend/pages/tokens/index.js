import React, { useState, useEffect } from "react";
import { makeStyles } from '@mui/styles';

// We'll use ethers to interact with the Ethereum network and our contract
import { ethers } from "ethers";

// We import the contract's artifacts and address here, as we are going to be
// using them with ethers
import contractAddress from "../../contracts/contract-address.json";

import NoWalletDetected from "./components/NoWalletDetected";
import ConnectWallet from "./components/ConnectWallet";
import Token from './components/Token'
import TokenSale from './components/TokenSale'

const useStyles = makeStyles(() => ({
  mainRoot: {
    padding: 20,
  }
}))


// This component is in charge of doing these things:
//   1. It connects to the user's wallet
//   2. Initializes ethers and the Token contract
//   3. Polls the user balance to keep it updated.
//   4. Transfers tokens by sending transactions
//   5. Renders the whole application
//
// Note that (3) and (4) are specific of this sample application, but they show
// you how to keep your Dapp and contract's state in sync,  and how to send a
// transaction.
const TokenManagement = (props) => {
  const classes = useStyles()

  // Ethereum wallets inject the window.ethereum object. If it hasn't been
  // injected, we instruct the user to install MetaMask.
  const [walletDetected, setWalletDetected] = useState(false)
  useEffect(() => {
    if (window.ethereum === undefined) {
      setWalletDetected(false)
    } else {
      setWalletDetected(true)

      const handleChainChanged = (_chainId) => {
        // We recommend reloading the page, unless you must do otherwise
        window.location.reload();
      }
      window.ethereum.on('chainChanged', handleChainChanged);
    }
  }, [])

  const [selectedAddress, setSelectedAddress] = useState(undefined)
  const [provider, setProvider] = useState(undefined)
  const [signer, setSigner] = useState(undefined)


  useEffect(() => {
    const initializeEthers = async () => {
      // A Web3Provider wraps a standard Web3 provider, which is
      // what MetaMask injects as window.ethereum into each page
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      setProvider(provider)

      // The MetaMask plugin also allows signing transactions to
      // send ether and pay to change state within the blockchain.
      // For this, you need the account signer...
      const signer = provider.getSigner(0)
      setSigner(signer)
    }

    initializeEthers()
  }, [])
  
 
  if (!walletDetected) {
    return (
      <div className={classes.mainRoot}>
        <NoWalletDetected/>
      </div>
    )
  }

  if (!selectedAddress) {
    return (
      <div className={classes.mainRoot}>
        <ConnectWallet
          selectedAddress={selectedAddress}
          setSelectedAddress={setSelectedAddress}
        />
      </div>
    )
  }

  return (
    <div className={classes.mainRoot}>
      <h1><b>Address:</b> {selectedAddress}</h1>
      <div>
        <h2>My wallet</h2>
        <Token
          tokenAddress={contractAddress.KEEYToken}
          selectedAddress={selectedAddress}
          signer={signer}
        />
        <Token
          tokenAddress={contractAddress.USDTToken}
          selectedAddress={selectedAddress}
          signer={signer}
        />
      </div>

      <div>
        <h2>Token sales</h2>
        <TokenSale
          contractAddress={contractAddress.TokenSale}
          selectedAddress={selectedAddress}
          signer={signer}
        />
      </div>
    </div>
  )
}

export default TokenManagement