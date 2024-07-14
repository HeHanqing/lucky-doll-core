# LuckyDoll Core

This repository contains the core smart contracts for the LuckyDoll NFT Protocol.More details about the LuckyDoll, see the [LuckyDoll website](https://luckydoll.netlify.app/).

## Feature Introduction

LuckyDoll is an [Ethereum-based Non-Fungible Token (NFT)](https://eips.ethereum.org/EIPS/eip-721) smart contract that offers a unique digital collectible experience. The LuckyDoll contract allows you to use AI to create, collect, and trade LuckyDoll NFTs with various lucky attributes. Each LuckyDoll possesses a randomly assigned level of luck, enhancing the enjoyment of collecting and gaming.

## Chainlink VRF 2_5

To ensure the fairness and randomness of the luck values generated, we have integrated [Chainlink VRF (Verifiable Random Function)](https://docs.chain.link/vrf) services into our LuckyDoll smart contract. This integration not only guarantees the unpredictability of each LuckyDoll's luck attribute but also provides a secure and verifiable source of randomness, which is critical for maintaining trust and integrity within our digital collectible ecosystem.

## Getting Started

Follow these steps to set up the project locally on your machine.

**Prerequisites**

Make sure you have the following installed on your machine:

- [Git](https://git-scm.com/)
- [Node.js](https://nodejs.org/en)
- [npm](https://www.npmjs.com/)(Node Package Manager)

**Clone the repository**

```shell
git https://github.com/HeHanqing/lucky-doll-core.git
cd lucky-doll-core
```

**Installation**

Install the project dependencies using npm:

```shell
npm install
```

**Usage**

Deploy:

```shell
npx hardhat deploy
```

Test:

```shell
npx hardhat test
```

Coverage:

```shell
npx hardhat coverage
```

## Deployment to a testnet or mainnet

**1.Setup environment variables**

You'll want to set your `SEPOLIA_RPC_URL` and `PRIVATE_KEY` as environment variables. You can add them to a `.env` file, similar to what you see in `.env.example`.

- `PRIVATE_KEY`: The private key of your account (like from [metamask](https://metamask.io/)). NOTE: FOR DEVELOPMENT, PLEASE USE A KEY THAT DOESN'T HAVE ANY REAL FUNDS ASSOCIATED WITH IT.
- `SEPOLIA_RPC_URL`: This is url of the sepolia testnet node you're working with. You can get setup with one for free from [Alchemy](https://www.alchemy.com/)

**2.Get testnet ETH**

Head over to [faucets.chain.link](https://faucets.chain.link/) and get some testnet ETH & LINK. You should see the ETH and LINK show up in your metamask.[You can read more on setting up your wallet with LINK](https://docs.chain.link/quickstarts/deploy-your-first-contract).

**3.Setup a Chainlink VRF Subscription ID**

Head over to [vrf.chain.link](https://vrf.chain.link/) and setup a new subscription, and get a subscriptionId. You can reuse an old subscription if you already have one.

[You can follow the instructions](https://docs.chain.link/vrf/v2-5/getting-started) if you get lost. You should leave this step with:

1. A subscription ID
2. Your subscription should be funded with LINK
3. Deploy

In your `helper-hardhat-config.js` add your `subscriptionId` under the section of the chainId you're using (aka, if you're deploying to sepolia, add your `subscriptionId` in the `subscriptionId` field under the `11155111` section.)

Then run:

```shell
npx hardhat deploy --network sepolia
```

## Thank you!

If you appreciated this, feel free to follow me or donate!

ETH/Polygon/Avalanche/etc Address: 0xA55d014862b8F997C1198C400b348BfAF24d2AE8
