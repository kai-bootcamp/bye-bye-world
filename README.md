# This is project to learn create a Dapp.

1. Create, deploy smart contract.
- [**Truffle Tutorial**](https://www.trufflesuite.com/tutorial) 
  ```
  $ truffle create contract TokenFactory
  $ truffle complie
  $ truffle create migration deploy_token_factory
  $ truffle create test TokenFactory
  $ truffle migrate
  $ truffle test
  ```

- **`TokenFactory`** contract to handle create New token.

- **`PoolSaleToken`** contract to handle salce New token.

2. Build UI Frontend to connect with smart contract.
- Use Flutter Web.