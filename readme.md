# Solidity Smart Contract Collection

Welcome to the repository where I store Solidity, Smart Contract and Blockchain knowledge and notes

# References

### [Patrick Collins](https://www.youtube.com/channel/UCn-3f8tw_E1jZvhuHatROwA)

### [Testnet Faucets](https://faucets.chain.link)

### [Chainlink](https://chain.link/)

### [Ethereum Unit Converter](https://eth-converter.com/)

### [Remix](https://remix.ethereum.org/)

### [Solidity Documentation](https://docs.soliditylang.org/en/v0.8.6/index.html)

# Fund Me Contract

## 💻 Code: https://github.com/buikhacnam/Solidity-smart-contract-collection/tree/master/fundMe

## Topic covers:

-   Chainlink
-   Import contract from chainlink
-   Convert ETH to USD
-   Ethereum to Wei and so on
-   Libraries and Solidity
-   Sending ETH from a Contract
-   Special functions receive() and fallback()
-   Custom error introduction

# Storage Contract

## 💻 Code: https://github.com/buikhacnam/Solidity-smart-contract-collection/tree/master/simpleStorage

## Topic covers:

### Compile contract using solc

Run: yarn compile (check it in package.json)

```

    "compile": "yarn solcjs --bin --abi --include-path node_modules/ --base-path . -o compile simpleStorage/SimpleStorage.sol"

```

--bin : we want the binary <br>
--abi: we want the abi <br>
--include-path: <br>
-- node_modules: we want contracts and files in the node_modules <br>
--base-path .: period means it will be in the base folder <br>
-o compile: output abi and bin to "compile" folder <br>
simpleStorage/SimpleStorage.sol: where to find the contract.sol file <br>

### Deploy contract to Ganache
💻 Code: https://github.com/buikhacnam/Solidity-smart-contract-collection/blob/master/deploy.js

```
const factory = new ethers.ContractFactory(abi, binary, wallet)
```

#### abi and binary are imported from compile folder

#### wallet private key is decrypted from a json file encryptKey.json
First, create encryptKey.json file:

```
const wallet = new ethers.Wallet(PRIVATE_KEY)
	const encryptedJsonKey = await wallet.encrypt(
		PRIVATE_KEY_PASSWORD,
		PRIVATE_KEY
	)
    console.log(encryptedJsonKey)
    fs.writeFileSync('./encryptKey.json', encryptedJsonKey)

```

Then, we can decrypt the private key:

```

	const encryptedJson = fs.readFileSync('./encryptKey.json', 'utf8')
	let wallet = new ethers.Wallet.fromEncryptedJsonSync(
		encryptedJson,
		process.env.PRIVATE_KEY_PASSWORD
	)

```

Run the deploy.js file to deploy the contract on Ganache:

```
PRIVATE_KEY_PASSWORD=yourpassword node deploy.js
```

To clear terminal history:
```
history -c
```
