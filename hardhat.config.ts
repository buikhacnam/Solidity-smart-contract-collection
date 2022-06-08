import { task } from 'hardhat/config'
import '@nomiclabs/hardhat-waffle'
import 'dotenv/config'
import '@nomiclabs/hardhat-etherscan'
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task('accounts', 'Prints the list of accounts', async (args, hre) => {
	const accounts = await hre.ethers.getSigners()

	for (const account of accounts) {
		console.log(await account.address)
	}
})

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const RINKEBY_PRIVATE_KEY = process.env.METAMASK_RINKEBY_PRIVATE_KEY!
const RINKEBY_RPC_URL = process.env.ALCHEMY_RINKEBY_RPC_URL!
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY!
console.log(
	'RINKEBY_PRIVATE_KEY: ',
	RINKEBY_PRIVATE_KEY,
	'RINKEBY_RPC_URL: ',
	RINKEBY_RPC_URL
)
export default {
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
		apiKey: ETHERSCAN_API_KEY,
	}
}
