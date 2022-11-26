import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  defaultNetwork: "ganache",
  networks: {
    ganache: {
      url: "http://127.0.0.1:7545",
      accounts: [
        "be88d2abc8e54091dc1f0e06d2e90945abe6442430fa7f75e4bab7a5c1dde346",
      ],
      chainId: 1337,
    },
  },
};

export default config;
