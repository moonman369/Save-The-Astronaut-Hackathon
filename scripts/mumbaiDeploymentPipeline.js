const { ethers } = require("hardhat");
require("dotenv").config();

const {
  deployAstroSuitFullNFT,
  deployDestinationMinter,
} = require("./deployFunctions");
const { ctorArgs } = require("./constructorArgs");

const mumbaiDeploymentPipeline = async () => {
  const [deployer2] = await ethers.getSigners();

  const { maxTokenSupply } = ctorArgs.AstroSuitFullNFT;
  const astroSuitFullNFT = await deployAstroSuitFullNFT(
    deployer2.address,
    deployer2.address,
    maxTokenSupply
  );

  const { routerAddress } = ctorArgs.DestinationMinter;
  const destinationMinter = await deployDestinationMinter(
    deployer2.address,
    routerAddress,
    astroSuitFullNFT.target
  );

  await (
    await astroSuitFullNFT
      .connect(deployer2)
      .transferOwnership(destinationMinter.target)
  ).wait();
  console.log(
    "Transfer AstroSuitFullNFT ownership to Destination Minter contract"
  );
};

mumbaiDeploymentPipeline()
  .then(() => {
    process.exit(0);
  })
  .catch((error) => console.error(error));
