import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';

// TODO: form validation

const BuyForm = (props) => {
  const { open, setOpen, buyTokens, tokenSaleData = { } } = props
  const { tokenPrice, remainingToken } = tokenSaleData
  const [formData, setFormData] = React.useState({})

  const handleClose = () => {
    setOpen(false);
  };

  const handleBuy = () => {
    setOpen(false)
    buyTokens(JSON.parse(formData["amount"] || 0))
  }

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    })
  }

  return (
    <Dialog open={open} onClose={handleClose}>
      <DialogTitle>Buy token</DialogTitle>
      <DialogContent>
        <DialogContentText>
          To buy tokens, please enter amount here.
        </DialogContentText>
        <TextField
          margin="dense"
          name="amount"
          label="Amount"
          type="number"
          fullWidth
          variant="standard"
          onChange={handleChange}
          helperText={`Remaining tokens: ${remainingToken}. Exchange rate: ${tokenPrice}`}
          required
        />
        <TextField
          margin="dense"
          name="amount"
          label="Total price"
          type="number"
          fullWidth
          disabled
          variant="standard"
          value={tokenPrice * JSON.parse(formData["amount"] || 0)}
          required
        />
      </DialogContent>
      <DialogActions>
        <Button onClick={handleClose}>Cancel</Button>
        <Button onClick={handleBuy}>Buy</Button>
      </DialogActions>
    </Dialog>
  );
}

export default BuyForm