# This is project to learn create a Dapp.

1. Create, deploy smart contract.
- [**Truffle Tutorial**](https://www.trufflesuite.com/tutorial) 
  ```
  /// create new smart contract
  $ truffle create contract TokenFactory

  /// complie smart contract
  $ truffle complie

  /// create migration to config deploy smart contract
  $ truffle create migration deploy_token_factory

  /// create smartcontract test
  $ truffle create test TokenFactory

  /// migrate smart contract
  $ truffle migrate

  /// run test
  $ truffle test
  ```

- **`TokenFactory`** contract to handle create New token.
   
   . Create New Token type ERC20.

   . Hanlde url image of follow address of token.

   . Handle Token Information was created.

- **`PoolSaleToken`** contract to handle sale New token.
  
   . Handle creare Token Sale pair.

   . Handle get infomation of Token Sale pair.

1. Build UI Frontend to connect with smart contract.
   
- Use Flutter Web.
  
- Upload image Token to IPFS.

1. Deploy use Firebase Hosting.
   
   https://bye-bye-worldvl.web.app/