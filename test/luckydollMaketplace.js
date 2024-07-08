const { expect } = require("chai");
const { ethers, getNamedAccounts, deployments } = require("hardhat");

describe("LuckyDoll", function () {
  let luckyDoll, vrfMock, account;

  beforeEach(async function () {
    const { deployer } = await getNamedAccounts();
    vrfCoordinatorV2Mock = await ethers.getContractAt("VRFMock");

    // const VRFMock = await ethers.getContractFactory("VRFMock");
    // vrfMock = await VRFMock.deploy(
    //   BigInt(100000000000000000),
    //   1000000000,
    //   4139787718341482
    // );

    // const s_subscriptionId = await vrfMock.createSubscription();
    // console.log(
    //   await ethers.provider.getTransactionReceipt(s_subscriptionId.hash)
    // );

    const LuckyDoll = await ethers.getContractFactory("LuckyDoll");
    luckyDoll = await LuckyDoll.deploy(
      BigInt(
        19473665017039486997494577471892920815114953743202950672248282172272094635393
      )
    );
  });
  it("Should be able to mint a new NFT", async function () {
    await luckyDoll.safeMint();
    // expect(luckyDoll.balanceOf(account.address)).to.be.equal(1);
  });
});

describe("NFTMarketplace", function () {
  let nftMarketplace, luckyDoll;

  beforeEach(async function () {
    const [account] = await ethers.getSigners();

    const LuckyDoll = await ethers.getContractFactory("LuckyDoll");
    luckyDoll = await LuckyDoll.deploy(account.address);

    const NFTMarketplace = await ethers.getContractFactory("NFTMarketplace");
    nftMarketplace = await NFTMarketplace.deploy(luckyDoll.target);
  });

  it("Should be able to create a new NFT", async function () {});
});
