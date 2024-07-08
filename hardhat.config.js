require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-ethers");
require("hardhat-deploy");

/** @type import('hardhat/config').HardhatUserConfig */
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const SEPOLIA_PRC_URL = process.env.SEPOLIA_PRC_URL;

module.exports = {
  solidity: {
    version: "0.8.24",
    settings: {
      optimizer: { enabled: true, runs: 1000 },
    },
  },
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 31337,
      blockConfirmations: 1,
    },
    sepolia: {
      chainId: 11155111,
      blockConfirmations: 6,
      url: `https://eth-sepolia.g.alchemy.com/v2/${SEPOLIA_PRC_URL}`,
      account: [`0x${PRIVATE_KEY}`],
    },
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
    player: {
      default: 1,
    },
  },
  allowUnlimitedContractSize: true,
};
