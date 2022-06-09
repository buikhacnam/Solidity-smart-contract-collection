// Get the block number of the current chain

import {task} from 'hardhat/config'

export default task('block-number', 'Get the block number of the current chain')
    .setAction(async (taskArgs: any[], hre:any) => {
        // hre.ethers can be a lot like { ether } from 'hardhat'
        const { ethers } = hre
        const blockNumber = await ethers.provider.getBlockNumber()
        console.log('current block number:', blockNumber.toString())
    })
