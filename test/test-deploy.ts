import { expect, assert } from 'chai'
import { ethers } from 'hardhat'
// import {SimpleStorage, SimpleStorage__factory} from '../typechain-types'
describe('simpleStorage', () => {
	// let simpleStorageFactory: SimpleStorage__factory
	// let simpleStorage: SimpleStorage
	let simpleStorage: any
	let simpleStorageFactory
	beforeEach(async () => {
		// simpleStorageFactory = (await ethers.getContractFactory('SimpleStorage')) as SimpleStorage__factory
		simpleStorageFactory = await ethers.getContractFactory('SimpleStorage')
		simpleStorage = await simpleStorageFactory.deploy()
	})

	it('should start with a value of 0', async () => {
		const currentValue = await simpleStorage.retrieve()
		const expectedValue = '0'
		assert.equal(currentValue.toString(), expectedValue)
		// expect(currentValue.toString()).to.equal(expectedValue)
	})

	it('Should update when we call store', async function () {
		const expectedValue = '7'
		const transactionResponse = await simpleStorage.store(expectedValue)
		await transactionResponse.wait(1)

		const currentValue = await simpleStorage.retrieve()
		assert.equal(currentValue.toString(), expectedValue)
	})
})
