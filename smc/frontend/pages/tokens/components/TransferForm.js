import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';

// TODO: form validation

const TransferForm = (props) => {
  const { open, setOpen, tokenSymbol, transferTokens, balance } = props
  const [formData, setFormData] = React.useState({})

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const handleTransfer = () => {
    transferTokens(
      formData["address"],
      JSON.parse(formData["amount"])
    )
    setOpen(false)
  }

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    })
  }

  return (
    <Dialog open={open} onClose={handleClose}>
      <DialogTitle>Transfer {tokenSymbol} token</DialogTitle>
      <DialogContent>
        <DialogContentText>
          To transfer tokens, please enter recipient address and amount here.
        </DialogContentText>
        <TextField
          autoFocus
          margin="dense"
          name="address"
          label="Address"
          type="text"
          fullWidth
          variant="standard"
          onChange={handleChange}
          required
        />
        <TextField
          margin="dense"
          name="amount"
          label="Amount"
          type="number"
          fullWidth
          variant="standard"
          onChange={handleChange}
          helperText={`Maximum: ${balance} (${tokenSymbol})`}
          required
        />
      </DialogContent>
      <DialogActions>
        <Button onClick={handleClose}>Cancel</Button>
        <Button onClick={handleTransfer}>Transfer</Button>
      </DialogActions>
    </Dialog>
  );
}

export default TransferForm