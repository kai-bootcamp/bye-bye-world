import React, { useState, useEffect } from 'react'
import { ethers } from "ethers";
import { makeStyles } from '@mui/styles'
import Button from '@mui/material/Button';
import Paper from '@mui/material/Paper';
import Grid from '@mui/material/Grid';

import TransferForm from './TransferForm'

import TokenArtifact from '../../../contracts/Token.json'

import { ERROR_CODE_TX_REJECTED_BY_USER } from '../../../constants/index'
import getErrorMessage from '../../../utils/getErrorMessage'

const useStyles = makeStyles(() => ({
  tokenRoot: {
    width: '100%',
    padding: 10,
  }
}))

const Token = (props) => {
  const classes = useStyles()

  const { tokenAddress, signer, selectedAddress } = props
  const [tokenData, setTokenData] = useState({})
  const [balance, setBalance] = useState(0)
  const [transactionError, setTransactionError] = useState(undefined)
  const [sendingTransaction, setSendingTransaction] = useState(undefined)

  const { token, name, symbol, totalSupply } = tokenData

  useEffect(() => {
    if (!tokenAddress) {
      return
    }
    const token = new ethers.Contract(tokenAddress, TokenArtifact.abi, signer);
    if (!token) return;
    const getTokenInfo = async () => {
      try {
        const tokenName = await token.name();
        const tokenSymbol = await token.symbol();
        const totalSupply = await token.totalSupply();

        setTokenData({
          token: token,
          name: tokenName,
          symbol: tokenSymbol,
          totalSupply: totalSupply.toNumber()
        });
      } catch (error) {
        console.log(error)
      }
    }

    getTokenInfo()
    updateBalance()
  }, [tokenAddress, signer])

  const updateBalance = async () => {
    if (!selectedAddress || !token) return;
    const newBalance = await token.balanceOf(selectedAddress);
    setBalance(newBalance.toNumber())
  }

  useEffect(() => {
    const pollingBalanceInterval = setInterval(() => updateBalance(), 1000);

    return () => {
      clearInterval(pollingBalanceInterval)
    }
  }, [token, selectedAddress])

  const transferTokens = async (to, amount) => {
    // Sending a transaction is a complex operation:
    //   - The user can reject it
    //   - It can fail before reaching the ethereum network (i.e. if the user
    //     doesn't have ETH for paying for the tx's gas)
    //   - It has to be mined, so it isn't immediately confirmed.
    //     Note that some testing networks, like Hardhat Network, do mine
    //     transactions immediately, but your dapp should be prepared for
    //     other networks.
    //   - It can fail once mined.
    //
    // This method handles all of those things, so keep reading to learn how to
    // do it.

    try {
      // If a transaction fails, we save that error in the component's state.
      // We only save one such error, so before sending a second transaction, we
      // clear it.
      setTransactionError(undefined)

      // We send the transaction, and save its hash in the Dapp's state. This
      // way we can indicate that we are waiting for it to be mined.
      const tx = await token.transfer(to, amount);
      setSendingTransaction(tx.hash)

      // We use .wait() to wait for the transaction to be mined. This method
      // returns the transaction's receipt.
      const receipt = await tx.wait();

      // The receipt, contains a status flag, which is 0 to indicate an error.
      if (receipt.status === 0) {
        // We can't know the exact error that made the transaction fail when it
        // was mined, so we throw this generic one.
        throw new Error("Transaction failed");
      }

      // If we got here, the transaction was successful, so you may want to
      // update your state. Here, we update the user's balance.
      await updateBalance();
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

  const [isTransferFormOpen, setIsTransferFormOpen] = useState(false)

  if (!token) {
    return null
  }

  return (
    <Grid container item xs={4}>
      <Paper elevation={2} className={classes.tokenRoot}>
          <h3>
            <b>Token:</b> {name}
          </h3>
          <h3>
            <b>Total supply:</b> {totalSupply} {symbol}
          </h3>
          <h3>
            <b>You have:</b> {balance} {symbol}
          </h3>
          
          <Button variant="outlined" onClick={() => setIsTransferFormOpen(true)}>Transfer</Button>
          <TransferForm
            open={isTransferFormOpen} 
            setOpen={setIsTransferFormOpen}
            tokenSymbol={symbol}
            transferTokens={transferTokens}
            balance={balance}
          />

          {sendingTransaction && <h4>Sending transaction: {sendingTransaction}</h4>}
          {transactionError && <h4>Error: {getErrorMessage(transactionError)}</h4>}
      </Paper>
    </Grid>
  )
}

export default Token