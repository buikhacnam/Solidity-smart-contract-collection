import {ethers}  from 'ethers'
import fs from 'fs-extra'
import 'dotenv/config' 


const main = async () => {
	//connect to ganache local blockchain

	// RPC server
	const provider = new ethers.providers.JsonRpcProvider(
		process.env.ALCHEMY_RINKEBY_RPC_URL!
	)

	const wallet = new ethers.Wallet(
		process.env.METAMASK_RINKEBY_PRIVATE_KEY!,
		provider
	)

	// get private key from encrypted json file instead
	// const encryptedJson = fs.readFileSync('./encryptKey.json', 'utf8')
	// let wallet = new ethers.Wallet.fromEncryptedJsonSync(
	// 	encryptedJson,
	// 	process.env.PRIVATE_KEY_PASSWORD
	// )
	// console.log('decrypted private key:', wallet.privateKey)
	// wallet = await wallet.connect(provider)

	//get the ABI and Binary:
	const abi = fs.readFileSync(
		'./compile/simpleStorage_SimpleStorage_sol_SimpleStorage.abi',
		'utf8'
	)

	const binary = fs.readFileSync(
		'./compile/simpleStorage_SimpleStorage_sol_SimpleStorage.bin',
		'utf8'
	)

	//Create contract factory - used to deploy contract
	// private key uses to sign and deploy contract
	const factory = new ethers.ContractFactory(abi, binary, wallet)
	console.log('deploying contract...')

	//deploy contract
	const contract = await factory.deploy()

	// wait for transaction to be mined and log it down
	const transactionReceipt = await contract.deployTransaction.wait(1)

	console.log(
		'------------------contract deployed at------------------: ',
		contract.address
	) // 0x73A55935EE0e082633c92FbD0a34e88f3a58357f
	console.log('-----------------contract------------------: ', contract)

	console.log(
		'-------------deployment transaction----------------: ',
		contract.deployTransaction
	)
	console.log(
		'-------------transaction receipt--------------: ',
		transactionReceipt
	)

	// test some functions
	const storeNumRes = await contract.store("10")
	const transactionReceipt2 = await storeNumRes.wait(1)


	const currentFavoriteNumber = await contract.retrieve()
	console.log('current favorite number: ', currentFavoriteNumber) //BigNumber { _hex: '0x00', _isBigNumber: true }
	console.log('current favorite number toString: ', currentFavoriteNumber.toString()) //10
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })

// A block confirmation is simply the act of your transaction being included in a block on the blockchain.
//Therefore, if your transaction has 3 block confirmations (see above graphic),
//then there have been 2 blocks mined since the block was mined that included your transaction.


// 0xa73f33bBbDB1436202f7302Fe69b9d3c345C30fd