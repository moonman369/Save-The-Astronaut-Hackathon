const { ethers } = require("hardhat");
require("dotenv").config();

const deploySourceMinter = async (
  deployerAddress,
  routerAddress,
  linkAddress
) => {
  const deployer = await ethers.getSigner(deployerAddress);

  const SourceMinter = await ethers.getContractFactory("SourceMinter");

  const sourceMinter = await SourceMinter.connect(deployer).deploy(
    routerAddress,
    linkAddress
  );

  await sourceMinter.waitForDeployment();

  console.log(
    `SourceMinter contract has been deployed at address: ${sourceMinter.target}\n`
  );

  return sourceMinter;
};

const deployAstroSuitPartsNFT = async (
  deployerAddress,
  initOwner,
  sourceMinterAddress,
  maxTokenSupply,
  maxTokenSupplyPerAddress
) => {
  const deployer = await ethers.getSigner(deployerAddress);

  const AstroSuitPartsNFT = await ethers.getContractFactory(
    "AstroSuitPartsNFT"
  );

  const astroSuitPartsNFT = await AstroSuitPartsNFT.connect(deployer).deploy(
    initOwner,
    sourceMinterAddress,
    maxTokenSupply,
    maxTokenSupplyPerAddress
  );

  await astroSuitPartsNFT.waitForDeployment();

  console.log(
    `AstroSuitPartsNFT contract has been deployed at address: ${astroSuitPartsNFT.target}\n`
  );

  return astroSuitPartsNFT;
};

const deployAstroSuitFullNFT = async (
  deployerAddress,
  initOwner,
  maxTokenSupply
) => {
  const deployer = await ethers.getSigner(deployerAddress);

  const AstroSuitFullNFT = await ethers.getContractFactory("AstroSuitFullNFT");

  const astroSuitFullNFT = await AstroSuitFullNFT.connect(deployer).deploy(
    initOwner,
    maxTokenSupply
  );

  await astroSuitFullNFT.waitForDeployment();

  console.log(
    `AstroSuitFullNFT contract has been deployed at address: ${astroSuitFullNFT.target}\n`
  );

  return astroSuitFullNFT;
};

const deployDestinationMinter = async (deployerAddress, router, nftAddress) => {
  const deployer = await ethers.getSigner(deployerAddress);

  const DestinationMinter = await ethers.getContractFactory(
    "DestinationMinter"
  );

  const destinationMinter = await DestinationMinter.connect(deployer).deploy(
    router,
    nftAddress
  );

  await destinationMinter.waitForDeployment();

  console.log(
    `DestinationMinter contract has been deployed at address: ${destinationMinter.target}\n\n`
  );

  return destinationMinter;
};

module.exports = {
  deploySourceMinter,
  deployAstroSuitPartsNFT,
  deployAstroSuitFullNFT,
  deployDestinationMinter,
};
