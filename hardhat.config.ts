import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();

// Environment variables
const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY;
const GOERLI_PRIVATE_KEY = process.env.GOERLI_PRIVATE_KEY;

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY!],
    },
    ganache: {
      url: "http://127.0.0.1:7545",
      accounts: [
        "52676e08113cbeb8fb8bcac4c8b2d100c0fe1a8adcbb8a466ad0814735718ded", // Replace with your ganache private key
      ],
      chainId: 1337,
    },
  },
};

export default config;
