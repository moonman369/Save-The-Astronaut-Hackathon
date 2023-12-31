require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.22",

  networks: {
    sepolia: {
      url: "https://sepolia.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161",
      accounts: [process.env.PRIVATE_KEY_S],
      chainId: 11155111,
      saveDeployments: true,
    },
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com/",
      accounts: [process.env.PRIVATE_KEY_M],
      chainId: 80001,
      saveDeployments: true,
    },
  },
};
