import React, { useState, useEffect } from 'react'
import { ethers } from "ethers";
import { makeStyles } from '@mui/styles'
import Button from '@mui/material/Button';
import Paper from '@mui/material/Paper';
import moment from 'moment'

import BuyForm from './BuyForm'

import TokenArtifact from '../../../contracts/Token.json'
import TokenSaleArtifact from '../../../contracts/TokenSale.json'
import { ERROR_CODE_TX_REJECTED_BY_USER } from '../../../constants/index'
import getErrorMessage from '../../../utils/getErrorMessage'

const useStyles = makeStyles(() => ({
  tokenSaleRoot: {
    padding: 10,
    marginBottom: 20,
  }
}))

const TokenSale = (props) => {
  const classes = useStyles()

  const { contractAddress, selectedAddress, signer } = props
  const [tokenSale, setTokenSale] = useState(undefined)
  const [tokenSaleData, setTokenSaleData] = useState({})
  const [transactionError, setTransactionError] = useState(undefined)
  const [sendingTransaction, setSendingTransaction] = useState(undefined)

  useEffect(() => {
    const tokenSale = new ethers.Contract(contractAddress, TokenSaleArtifact.abi, signer);
    setTokenSale(tokenSale)

    updateTokenSaleData()
  }, [contractAddress, signer])


  const updateTokenSaleData = async () => {
    if (!tokenSale) return;
    try {
      const tokenSaleData = await Promise.all([
        tokenSale.usdtContract(),
        tokenSale.keeyContract(),
        tokenSale.tokenPrice(),
        tokenSale.remainingToken(),
        tokenSale.startTimestamp(),
        tokenSale.endTimestamp(),
      ])

      // The Contract object
      const sourceToken = new ethers.Contract(tokenSaleData[0], TokenArtifact.abi, signer);
      const sourceTokenName = await sourceToken.name();
      const sourceTokenSymbol = await sourceToken.symbol();

      const targetToken = new ethers.Contract(tokenSaleData[1], TokenArtifact.abi, signer);
      const targetTokenName = await targetToken.name();
      const targetTokenSymbol = await targetToken.symbol();

      setTokenSaleData({
        usdtContract: tokenSaleData[0],
        keeyContract: tokenSaleData[1],
        sourceToken: {
          token: sourceToken,
          name: sourceTokenName,
          symbol: sourceTokenSymbol,
        },
        targetToken: {
          token: sourceToken,
          name: targetTokenName,
          symbol: targetTokenSymbol,
        },
        tokenPrice: tokenSaleData[2].toNumber(),
        remainingToken: tokenSaleData[3].toNumber(),
        startTimestamp: tokenSaleData[4].toNumber(),
        endTimestamp: tokenSaleData[5].toNumber(),
      });
    } catch (error) {
      setTokenSale(null)
      console.log(error)
    }
  }

  useEffect(() => {
    const pollingTokenSaleInterval = setInterval(() => updateTokenSaleData(), 1000);

    return () => {
      clearInterval(pollingTokenSaleInterval)
    }
  }, [tokenSale])

  const approveAllowance = async (address, amount) => {
    const { sourceToken } = tokenSaleData

    const approveTx = await sourceToken.token.approve(address, amount);
    setSendingTransaction(approveTx.hash);
    const approveReceipt = await approveTx.wait();
    if (approveReceipt.status === 0) {
      throw new Error("Approve transaction failed");
    }
  }

  const buyTokens = async (amount) => {
    // 1. Approve spent by tokenSale
    // 2. Request buyTokens
    try {
      // If a transaction fails, we save that error in the component's state.
      // We only save one such error, so before sending a second transaction, we
      // clear it.
      setTransactionError(undefined)

      const { sourceToken, tokenPrice } = tokenSaleData

      // Approve tokenSale to consume source tokens
      // Check current allowance first
      const currentAllowance = await sourceToken.token.allowance(selectedAddress, tokenSale.address);
      if (currentAllowance.toNumber() !== 0) {
        await approveAllowance(tokenSale.address, 0)
      }

      await approveAllowance(tokenSale.address, tokenPrice * amount)

      // We send the transaction, and save its hash in the Dapp's state. This
      // way we can indicate that we are waiting for it to be mined.
      const buyTokensTx = await tokenSale.buyTokens(amount);
      setSendingTransaction(buyTokensTx.hash);

      // We use .wait() to wait for the transaction to be mined. This method
      // returns the transaction's receipt.
      const buyTokenReceipt = await buyTokensTx.wait();

      // The receipt, contains a status flag, which is 0 to indicate an error.
      if (buyTokenReceipt.status === 0) {
        // We can't know the exact error that made the transaction fail when it
        // was mined, so we throw this generic one.
        throw new Error("Buy tokens transaction failed");
      }

      // If we got here, the transaction was successful, so you may want to
      // update your state. Here, we update the user's balance.
      await updateTokenSaleData();
    } catch (error) {
      // We check the error code to see if this error was produced because the
      // user rejected a tx. If that's the case, we do nothing.
      if (error.code === ERROR_CODE_TX_REJECTED_BY_USER) {
        return;
      }

      // Other errors are logged and stored in the Dapp's state. This is used to
      // show them to the user, and for debugging.
      console.error(error);
      setTransactionError(error);
    } finally {
      // If we leave the try/catch, we aren't sending a tx anymore, so we clear
      // this part of the state.
      setSendingTransaction(undefined)
    }
  }

  const [isBuyFormOpen, setIsBuyFormOpen] = useState(false)

  const { sourceToken, targetToken, tokenPrice, remainingToken, startTimestamp, endTimestamp } = tokenSaleData

  const buyDisabled = (moment().unix() > endTimestamp) || (remainingToken === 0)

  if (!tokenSale) {
    return null
  }

  return (
    <Paper elevation={2} className={classes.tokenSaleRoot}>
      <h2>
        Token sale
      </h2>
      <h3>
        Target token: {targetToken?.symbol}
      </h3>
      <h3>
        Source token: {sourceToken?.symbol}
      </h3>
      <h3>
        Exchange rate: {tokenPrice}
      </h3>
      <h3>
        Remaining tokens: {remainingToken}
      </h3>
      <h4>
        Starting date: {moment.unix(startTimestamp).format("HH:mm:ss - DD/MM/YYYY")}
      </h4>
      <h4>
        Ending date: {moment.unix(endTimestamp).format("HH:mm:ss - DD/MM/YYYY")}
      </h4>

      <Button
        variant="outlined"
        onClick={() => setIsBuyFormOpen(true)}
        disabled={buyDisabled}
      >
        Buy
      </Button>
      {(moment().unix() > endTimestamp) &&
        <p>Sale ended</p>
      }
      {(remainingToken === 0) &&
        <p>Out of sale tokens</p>
      }
      <BuyForm
        open={isBuyFormOpen}
        setOpen={setIsBuyFormOpen}
        tokenSaleData={tokenSaleData}
        buyTokens={buyTokens}
      />

      {sendingTransaction && <h4>Sending transaction: {sendingTransaction}</h4>}
      {transactionError && <h4>Error: {getErrorMessage(transactionError)}</h4>}
    </Paper>
  )
}

export default TokenSale