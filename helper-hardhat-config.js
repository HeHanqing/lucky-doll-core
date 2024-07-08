const networkConfig = {
  11155111: {
    name: "sepolia",
    vrfCoordinatorV2Plus: "0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B",
    subscriptionId:
      "44465163623070523247322816735192971151913530976085468914448470275447731303356",
  },
  31337: {
    name: "hardhat",
  },
};

const developmentChains = ["hardhat", "localhost"];

module.exports = {
  networkConfig,
  developmentChains,
};
