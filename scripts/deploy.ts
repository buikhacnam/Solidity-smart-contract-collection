import { ethers, run, network } from 'hardhat'
import 'dotenv/config' 

async function main() {
	console.log('network', network)

	const SimpleStorageFactory = await ethers.getContractFactory(
		'SimpleStorage'
	)
	console.log('deploying contract...')
	const contract = await SimpleStorageFactory.deploy()
	await contract.deployed()

	console.log('deployed contract at:', contract.address) 
	
	// check if the network is rinkeby or not
	if(network.name === 'rinkeby' && (process.env.ETHERSCAN_API_KEY)) {
		console.log('network is rinkeby. verifying contract...')
		// wait for a few blocks mined to make sure the contract is deployed
		await contract.deployTransaction.wait(3)
		await verify(contract.address, [])
	} else {
		console.log('will not verify')
	}

	// call retrieve() function
	const currentValue = await contract.retrieve()
	console.log('current value:', currentValue.toString())

	// call store() function
	const newValue = await contract.store(42)
	await newValue.wait(1)

	// call retrieve() function again
	const currentValue2 = await contract.retrieve()
	console.log('updated value:', currentValue2.toString())

}

async function verify(constractAddress: string, args: any[]) {
	console.log('verifying contract...')
	//reference: https://hardhat.org/plugins/nomiclabs-hardhat-etherscan
	try {
		await run('verify:verify', {
			address: constractAddress,
			constructorArguments: args,
		})
		// https://rinkeby.etherscan.io/address/0xB4C5EB615693634D826B00c23749Cea5F89b9739#code
	} catch (err:any) {
		if(err.message.toLowerCase().includes('already verified')) {
			console.log('already verified')
		} else {
			console.log(err)
		}
	}
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error)
		process.exit(1)
	})
