const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NFTMarketplace", function () {
  let nftMarketplace, luckyDoll;

  beforeEach(async function () {
    const [account] = await ethers.getSigners();

    const LuckyDoll = await ethers.getContractFactory("LuckyDoll");
    luckyDoll = await LuckyDoll.deploy(account.address);

    const NFTMarketplace = await ethers.getContractFactory("NFTMarketplace");
    nftMarketplace = await NFTMarketplace.deploy(luckyDoll.target);

    console.log(nftMarketplace.target, luckyDoll.target);
  });

  it("Should be able to create a new NFT", async function () {});
});
