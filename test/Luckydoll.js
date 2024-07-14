const { network, deployments, getNamedAccounts, ethers } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config");
const { expect } = require("chai");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");

!developmentChains.includes(network.name)
  ? describe.skip
  : describe("luckydollMaketplace", () => {
      let luckyDoll, vrfCoordinatorV2_5Mock, player;
      const chainId = network.config.chainId;

      beforeEach(async function () {
        deployer = (await getNamedAccounts()).deployer;
        player = (await getNamedAccounts()).player;
        await deployments.fixture(["all"]);
        luckyDoll = await ethers.getContract("LuckyDoll", deployer);
        vrfCoordinatorV2_5Mock = await ethers.getContract(
          "VRFCoordinatorV2_5Mock",
          deployer
        );
      });

      describe("constructor", async function () {
        it("Initializes the luckyDoll correctly", async function () {
          expect(await luckyDoll.s_vrfCoordinatorV2Plus()).to.equal(
            vrfCoordinatorV2_5Mock.target
          );
        });
      });
      describe("safeMint", async function () {
        beforeEach(async function () {
          await luckyDoll.safeMint("test", "test", "test", "test");
          await luckyDoll.safeMint("test", "test", "test", "test");
        });
        it("safeMint currently", async function () {
          expect(await luckyDoll.safeMint("test", "test", "test", "test"))
            .to.emit(luckyDoll, "NFTMinted")
            .withArgs(deployer, 2);
          expect(await luckyDoll.balanceOf(deployer)).to.equal(3);
          expect(await luckyDoll.getOwner(0)).to.equal(deployer);
        });

        it("requestId currently", async function () {
          await expect(
            vrfCoordinatorV2_5Mock.fulfillRandomWords(0, luckyDoll.target)
          ).to.be.revertedWithCustomError(
            vrfCoordinatorV2_5Mock,
            "InvalidRequest"
          );
          expect(await luckyDoll.getRequestIdToTokenId(1)).to.equal(0);
          expect(await luckyDoll.getRequestIdToTokenId(2)).to.equal(1);
        });
      });

      describe("LuckLevel create successfully", async function () {
        beforeEach(async function () {
          await luckyDoll.safeMint("test", "test", "test", "test");
          await luckyDoll.safeMint("test", "test", "test", "test");
        });
        it("event should successfully emit", async function () {
          expect(await vrfCoordinatorV2_5Mock.fulfillRandomWords(1, luckyDoll))
            .to.emit(luckyDoll, "LuckyLevelCreated")
            .withArgs(deployer, 0, anyValue);
        });

        it("luckLevel should correctly", async function () {
          await vrfCoordinatorV2_5Mock.fulfillRandomWords(1, luckyDoll);
          expect(await luckyDoll.getLuckyLevel(0)).to.equal("High_Luck");
        });
      });

      describe("setTokenURI", async function () {
        it("If not the owner", async function () {
          await luckyDoll.safeMint("test", "test", "test", "test");
          expect(await luckyDoll.getOwner(0)).to.equal(deployer);
        });
      });
    });
