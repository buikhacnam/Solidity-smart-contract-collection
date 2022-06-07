import ethers  from 'ethers'
import fs from 'fs-extra'
import 'dotenv/config' 

const main = async () => {
	const wallet = new ethers.Wallet(process.env.PRIVATE_KEY)
	const encryptedJsonKey = await wallet.encrypt(
		process.env.PRIVATE_KEY_PASSWORD,
		process.env.PRIVATE_KEY
	)
    console.log(encryptedJsonKey)
    fs.writeFileSync('./encryptKey.json', encryptedJsonKey)
}

main()
