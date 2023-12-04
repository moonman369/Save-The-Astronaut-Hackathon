const { ethers } = require("hardhat");
require("dotenv").config();

const {
  deploySourceMinter,
  deployAstroSuitPartsNFT,
} = require("./deployFunctions");
const { ctorArgs } = require("./constructorArgs");

const sepoliaDeploymentPipeline = async () => {
  const [deployer1] = await ethers.getSigners();

  const { routerAddress, linkAddress } = ctorArgs.SourceMinter;
  const sourceMinter = await deploySourceMinter(
    deployer1.address,
    routerAddress,
    linkAddress
  );

  const { maxTokenSupply, maxTokenSupplyPerAddress } =
    ctorArgs.AstroSuitPartsNFT;
  const astroSuitPartsNFT = await deployAstroSuitPartsNFT(
    deployer1.address,
    deployer1.address,
    sourceMinter.target,
    maxTokenSupply,
    maxTokenSupplyPerAddress
  );

  await (
    await sourceMinter
      .connect(deployer1)
      .setAstroPartsNft(astroSuitPartsNFT.target)
  ).wait();
  console.log(`Set AstroSuitPartsNFT in SourceMinterContract.`);
};

sepoliaDeploymentPipeline()
  .then(() => {
    process.exit(0);
  })
  .catch((error) => console.error(error));
