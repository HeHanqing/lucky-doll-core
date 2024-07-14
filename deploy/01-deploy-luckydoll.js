const { ethers, network } = require("hardhat");
const {
  developmentChains,
  networkConfig,
} = require("../helper-hardhat-config");
const { verify } = require("../utils/verify");

const VRF_SUB_FUND_AMOUNT = ethers.parseEther("100");

module.exports = async function ({ getNamedAccounts, deployments }) {
  const { deploy } = deployments;
  const { deployer: hardhatDeployer } = await getNamedAccounts();

  const [deployer] = await ethers.getSigners();
  console.log(deployer.address);

  const chainId = network.config.chainId;
  let vrfCoordinatorV2_5Address, subscriptionId, vrfCoordinatorV2_5Mock;

  if (developmentChains.includes(network.name)) {
    vrfCoordinatorV2_5Mock = await ethers.getContract("VRFCoordinatorV2_5Mock");
    vrfCoordinatorV2_5Address = vrfCoordinatorV2_5Mock.target;
    const transactionResponse =
      await vrfCoordinatorV2_5Mock.createSubscription();
    const transactionReceipt = await transactionResponse.wait(1);
    subscriptionId = transactionReceipt.logs[0].args[0];

    await vrfCoordinatorV2_5Mock.fundSubscription(
      subscriptionId,
      VRF_SUB_FUND_AMOUNT
    );
  } else {
    vrfCoordinatorV2_5Address = networkConfig[chainId]["vrfCoordinatorV2_5"];
    subscriptionId = networkConfig[chainId]["subscriptionId"];
  }

  const args = [vrfCoordinatorV2_5Address, subscriptionId];

  const LuckyDoll = await deploy("LuckyDoll", {
    from: developmentChains.includes(network.name)
      ? hardhatDeployer
      : deployer.address,
    args: args,
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });

  if (
    !developmentChains.includes(network.name) &&
    process.env.ETHERSCAN_API_KEY
  ) {
    console.log("Verifying contract...");
    await verify(LuckyDoll.address, args);
  } else {
    await vrfCoordinatorV2_5Mock.addConsumer(subscriptionId, LuckyDoll.address);
  }

  console.log("-----------------------------");
};

module.exports.tags = ["all", "luckydoll"];
