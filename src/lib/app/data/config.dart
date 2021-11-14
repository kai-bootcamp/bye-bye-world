class Node {
  final String url;
  final int chainId;
  final String name;
  final String baseSymbol;
  final String explore;
  const Node({
    required this.url,
    required this.chainId,
    required this.name,
    required this.baseSymbol,
    required this.explore,
  });
}

const rinkeby = Node(
  url: "https://rinkeby.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161",
  chainId: 4,
  name: "Rinkeby Test Network",
  baseSymbol: "ETH",
  explore: "https://rinkeby.etherscan.io",
);

const ganache = Node(
  url: "http://127.0.0.1:7545",
  chainId: 1337,
  name: "Ganache",
  baseSymbol: "ETH",
  explore: "",
);

const poolSaleTokenAbi = '''[
  {
    "inputs": [
      {"internalType": "uint256", "name": "tokenId", "type": "uint256"},
      {"internalType": "uint256", "name": "baseAmount", "type": "uint256"}
    ],
    "name": "buySaleToken",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "tokenSale_", "type": "address"},
      {"internalType": "address", "name": "tokenBase_", "type": "address"},
      {"internalType": "uint256", "name": "totalSale_", "type": "uint256"},
      {"internalType": "uint256", "name": "saleRate_", "type": "uint256"},
      {"internalType": "uint256", "name": "baseRate_", "type": "uint256"},
      {"internalType": "uint256", "name": "maxCap_", "type": "uint256"},
      {"internalType": "uint256", "name": "minCap_", "type": "uint256"}
    ],
    "name": "createTokenSale",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "uint256", "name": "tokenId", "type": "uint256"}
    ],
    "name": "getOwnerOfTokenSale",
    "outputs": [
      {"internalType": "address", "name": "", "type": "address"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "uint256", "name": "tokenSaleId", "type": "uint256"}
    ],
    "name": "getTokenSaleOfId",
    "outputs": [
      {
        "components": [
          {"internalType": "address", "name": "tokenSale", "type": "address"},
          {"internalType": "address", "name": "tokenBase", "type": "address"},
          {"internalType": "uint256", "name": "totalSale", "type": "uint256"},
          {"internalType": "uint256", "name": "totalSold", "type": "uint256"},
          {"internalType": "uint256", "name": "saleRate", "type": "uint256"},
          {"internalType": "uint256", "name": "baseRate", "type": "uint256"},
          {"internalType": "uint256", "name": "maxCap", "type": "uint256"},
          {"internalType": "uint256", "name": "minCap", "type": "uint256"},
          {"internalType": "uint256", "name": "tokenId", "type": "uint256"},
          {"internalType": "bool", "name": "isActive", "type": "bool"}
        ],
        "internalType": "struct PoolSaleToken.TokenSale",
        "name": "",
        "type": "tuple"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "tokenSaleInfo",
    "outputs": [
      {
        "components": [
          {"internalType": "address", "name": "tokenSale", "type": "address"},
          {"internalType": "address", "name": "tokenBase", "type": "address"},
          {"internalType": "uint256", "name": "totalSale", "type": "uint256"},
          {"internalType": "uint256", "name": "totalSold", "type": "uint256"},
          {"internalType": "uint256", "name": "saleRate", "type": "uint256"},
          {"internalType": "uint256", "name": "baseRate", "type": "uint256"},
          {"internalType": "uint256", "name": "maxCap", "type": "uint256"},
          {"internalType": "uint256", "name": "minCap", "type": "uint256"},
          {"internalType": "uint256", "name": "tokenId", "type": "uint256"},
          {"internalType": "bool", "name": "isActive", "type": "bool"}
        ],
        "internalType": "struct PoolSaleToken.TokenSale[]",
        "name": "",
        "type": "tuple[]"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  }
]''';

const tokenFactoryAbi = '''[
  {
    "inputs": [
      {"internalType": "address", "name": "poolSaleToken", "type": "address"},
      {"internalType": "string", "name": "name_", "type": "string"},
      {"internalType": "string", "name": "symbol_", "type": "string"},
      {"internalType": "string", "name": "url_", "type": "string"},
      {"internalType": "uint8", "name": "decimal_", "type": "uint8"},
      {"internalType": "uint256", "name": "totalSupply_", "type": "uint256"}
    ],
    "name": "create",
    "outputs": [
      {"internalType": "address", "name": "", "type": "address"}
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "token", "type": "address"}
    ],
    "name": "informationOfToken",
    "outputs": [
      {"internalType": "string", "name": "name_", "type": "string"},
      {"internalType": "string", "name": "symbol_", "type": "string"},
      {"internalType": "uint8", "name": "decimal_", "type": "uint8"},
      {"internalType": "uint256", "name": "totalSupply_", "type": "uint256"},
      {"internalType": "string", "name": "url_", "type": "string"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "creator", "type": "address"}
    ],
    "name": "tokenOf",
    "outputs": [
      {"internalType": "address", "name": "", "type": "address"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "token", "type": "address"}
    ],
    "name": "tokenUrl",
    "outputs": [
      {"internalType": "string", "name": "", "type": "string"}
    ],
    "stateMutability": "view",
    "type": "function"
  }
]''';

const tokenAbi = '''[
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "creator_",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "poolSaleToken",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "name_",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "symbol_",
				"type": "string"
			},
			{
				"internalType": "uint8",
				"name": "decimal_",
				"type": "uint8"
			},
			{
				"internalType": "uint256",
				"name": "totalSupply_",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "spender",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "value",
				"type": "uint256"
			}
		],
		"name": "Approval",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "from",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "value",
				"type": "uint256"
			}
		],
		"name": "Transfer",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "spender",
				"type": "address"
			}
		],
		"name": "allowance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "spender",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "approve",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "account",
				"type": "address"
			}
		],
		"name": "balanceOf",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "creator",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "decimals",
		"outputs": [
			{
				"internalType": "uint8",
				"name": "",
				"type": "uint8"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "spender",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "subtractedValue",
				"type": "uint256"
			}
		],
		"name": "decreaseAllowance",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "spender",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "addedValue",
				"type": "uint256"
			}
		],
		"name": "increaseAllowance",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "name",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "symbol",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "totalSupply",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "recipient",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "transfer",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "sender",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "recipient",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "transferFrom",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]''';
