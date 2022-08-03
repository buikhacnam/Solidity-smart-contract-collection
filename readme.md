# Solidity Smart Contract Collection

Welcome to the repository where I store Solidity, Smart Contract and Blockchain knowledge and notes

# NFT Playground

## 💻 Github Repository: https://github.com/buikhacnam/nft-playground

# Aave v2 Defi

## 💻 Github Repository: https://github.com/buikhacnam/defi-aave-v2-hardhat

# Hardhat TypeScript Lottery Smart Contract

## 💻 Back-end Repository: [https://github.com/buikhacnam/hardhat-lottery](https://github.com/buikhacnam/hardhat-lottery)

## 💻 Front-end Repository: [https://github.com/buikhacnam/next-lottery](https://github.com/buikhacnam/next-lottery)

# Hardhat Typescript FundMe Smart Contract

## 💻 Github Repository: https://github.com/buikhacnam/hardhat-fundme


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

### Deploy contract

💻 Code: https://github.com/buikhacnam/Solidity-smart-contract-collection/blob/master/deploy.ts

```
const factory = new ethers.ContractFactory(abi, binary, wallet)
```

#### abi and binary are imported from compile folder

#### wallet private key is decrypted from a json file encryptKey.json

You can get private key from https://trufflesuite.com/ganache/ and deploy to Ganache local network or use https://www.alchemy.com/ to deploy to real Rinkeby network

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

# Hardhat Storage Contract

## Basic Sample Hardhat Project

https://hardhat.org/

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```
shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help

```

## Deploy contract to Hardhat network

By default, Hardhat will automatically find the SimpleStorage.sol in the "contract" folder and then connect to the Hardhat network with default private key and rpc url

Here's the way to connect (scripts/deploy.ts):

```
import { ethers } from 'hardhat'

const SimpleStorageFactory = await ethers.getContractFactory(
		'SimpleStorage'
	)
    console.log("deploying contract...")
    const contract = await SimpleStorageFactory.deploy()
    await contract.deployed()

    console.log('deployed contract at:', contract.address)
```

Then you can deploy it by running:

```
yarn hardhat run scripts/deploy.ts
```

Or you can tell specific which network you want to deploy: (ex: rinkeby)

```
yarn hardhat run scripts/deploy.ts --network rinkeby
```

But first you need to provide the information of your private key and rpc url of that network in "hardhat.config.js" file:

```
{
	defaultNetwork: 'hardhat',
	networks: {
		rinkeby: {
			url: RINKEBY_RPC_URL,
			accounts: [RINKEBY_PRIVATE_KEY],
			chainId: 4, //rinkeby chainId
		},
	},
	solidity: '0.8.8',
}
```

## Verify contract on Etherscan

@nomiclabs/hardhat-etherscan plugin reference: https://hardhat.org/plugins/nomiclabs-hardhat-etherscan

First, get the API key from https://etherscan.io/myapikey

Then, add it to "hardhat.config.js" file:

```
import '@nomiclabs/hardhat-etherscan'
{
	defaultNetwork: 'hardhat',
	networks: {
		rinkeby: {
			url: RINKEBY_RPC_URL,
			accounts: [RINKEBY_PRIVATE_KEY],
			chainId: 4, //rinkeby chainId
		},
	},
	solidity: '0.8.8',
	etherscan: {
		apiKey: YOUR_API_KEY,
	},
}
```

Then, you can verify the contract on Etherscan by following :

```
import { run, network } from 'hardhat'

if(network.name === 'rinkeby' && process.env.ETHERSCAN_API_KEY) {
	try {
		await run('verify:verify', {
			address: CONTRACT_ADDRESS,
			constructorArguments: ARGS,
		})

	} catch (err:any) {
		if(err.message.toLowerCase().includes('already verified')) {
			console.log('already verified')
		} else {
			console.log(err)
		}
	}
}

```

Example Result: https://rinkeby.etherscan.io/address/0xB4C5EB615693634D826B00c23749Cea5F89b9739#code

## Hardhat Tasks

You can see all the tasks by running:

```
yarn hardhat
```

Similar to Scripts, Tasks basically can be used to achieve the same goal.

For example, we want to create a task the can see the block number of the network.

First, create the folder tasks.

Then, create the file tasks/block-number.ts:

```
// Get the block number of the current chain

import {task} from 'hardhat/config'

task('block-number', 'Get the block number of the current chain')
    .setAction(async (taskArgs: any[], hre:any) => {
        // hre.ethers can be a lot like { ether } from 'hardhat'
        const { ethers } = hre
        const blockNumber = await ethers.provider.getBlockNumber()
        console.log('current block number:', blockNumber.toString())
    })

export default {}
```

Then, you can run the task by following:

```
yarn hardhat block-number --network rinkeby
```

## Hardhat Localhost Node

Run the following command to start a local node:

```
yarn hardhat node
```

Using local node is useful for testing because it doesn't require a network and it's faster.

Now we add localhost network to "hardhat.config.js" file:

```
{
	...,
	networks: {
		...,
		localhost: {
			url: 'http://127.0.0.1:8545',
			chainId: 31337,
			// accounts: hardhat localhost node will pick up the first account
		}
	}
}
```

Now we can open a new terminal and run the following command:

```
yarn hardhat run scripts/deploy.ts --network rinkeby
```

## Testing using Chai

Testing in a nutshell:

```
class Car {
	park() {
		return 'stopped'
	}
	drive() {
		return 'vroom'
	}
}
let car
// before run each it block, run this function
beforeEach(() => {
	car = new Car()
})
// describe the 'Car' test
describe('Car Test', () => {
	it('can park', () => {
		assert.equal(car.park(), 'stopped')
	})
	it.only('can drive', () => { // it.only means only run this test
		assert.equal(car.drive(), 'vroom')
	})
})
```
💻 Code: https://github.com/buikhacnam/Solidity-smart-contract-collection/blob/master/test/test-deploy.ts

Run the following command to run the test:

```
yarn hardhat test
```

Run the test by keyword:

```
yarn hardhat test --grep 'TEST KEYWORD'
```

### hardhat-gas-reporter

`hardhat-gas-reporter` is a plugin that will report gas usage of each transaction every time we run test above.

Install it by following:

```
yarn add hardhat-gas-reporter
```

Then, add it to "hardhat.config.js" file:

```
{
	...,
	gasReporter: {
		enabled: true,
		outputFile: 'gas-report.json',
		noColors: true,
		currency: 'USD',
		coinmarketcap: MARKETCAP_API_KEY
	}
}

```
Get the MARKETCAP_API_KEY key from https://pro.coinmarketcap.com/

### solidity-coverage
`solidity-coverage` is a plugin that will generate a Testing coverage report of your smart contract.

Import the package to the 'hardhat.config.js' file:

```
import 'solidity-coverage'
```

Get the report by following:

```
yarn hardhat coverage
```

### Typechain

Reference: https://github.com/dethcrypto/TypeChain/tree/master/packages/hardhat

This library will generate types for smart contracts


# References

### [Patrick Collins](https://www.youtube.com/channel/UCn-3f8tw_E1jZvhuHatROwA)

### [Testnet Faucets](https://faucets.chain.link)

### [Chainlink](https://chain.link/)

### [Hardhat](https://hardhat.org/)

### [Ethereum Unit Converter](https://eth-converter.com/)

### [Remix](https://remix.ethereum.org/)

### [Solidity Documentation](https://docs.soliditylang.org/en/v0.8.6/index.html)



# Intro to Solidity and Smart Contract

## Github repository: https://github.com/buikhacnam/your-first-smart-contract
