import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-deploy";
import "hardhat-deploy-ethers";
import "hardhat-contract-sizer";
import '@typechain/hardhat'

function getMnemonic(networkName: string = "") {
  if (networkName) {
    const mnemonic = process.env['MNEMONIC_' + networkName.toUpperCase()]
    console.log(mnemonic);
    if (mnemonic && mnemonic !== '') {
      return mnemonic;
    }
    return process.env.MNEMONIC;
  }

  let mnemonic = process.env.MNEMONIC

  if (!mnemonic || mnemonic === '') {
    mnemonic = 'test test test test test test test test test test test junk'
  }

  return mnemonic
}

function accounts(chainKey: string = "") {
  if (process.env.PRIVATE_KEY) return [process.env.PRIVATE_KEY] as any
  return { mnemonic: getMnemonic(chainKey) as any }
}



const config: HardhatUserConfig = {
  solidity: "0.8.27",
  namedAccounts: {
    deployer: {
      default: 0, // here this will by default take the first account as deployer
    },
  },
  networks: {
    local: {
      url: `http://127.0.0.1:8545`,
      chainId: 31337,
      accounts: accounts(),
    },
    fuji: {
      url: `https://api.avax-test.network/ext/bc/C/rpc`,
      chainId: 43113,
      accounts: accounts(),
    }
  }
};

export default config;
