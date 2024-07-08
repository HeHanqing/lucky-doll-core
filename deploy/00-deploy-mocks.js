const { network, ethers } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config");

const BASE_FEE = ethers.parseEther("0.1");
const GAS_PRICE_LINK = 1000000000;
const WEIPERUNITLINK = 4381470000000000;

module.exports = async function ({ getNamedAccounts, deployments }) {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const args = [BASE_FEE, GAS_PRICE_LINK, WEIPERUNITLINK];

  if (developmentChains.includes(network.name)) {
    console.log("Local network deteched! Deploying mocks...");

    await deploy("VRFCoordinatorV2_5Mock", {
      from: deployer,
      log: true,
      args: args,
    });
    console.log("Mocks Deployed!");
    console.log("-------------------------------------------");
  }
};

module.exports.tags = ["all", "mocks"];
