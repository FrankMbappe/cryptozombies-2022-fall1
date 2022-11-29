import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();

// Environment variables
const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY;
const GOERLI_PRIVATE_KEY = process.env.GOERLI_PRIVATE_KEY;

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  defaultNetwork: "goerli",
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY!],
    },
    ganache: {
      url: "http://127.0.0.1:7545",
      accounts: [
        "a4a11159ecdb8598f9c66f5ebee3c952147843cec3a59352e92778d1a517faf2",
      ],
      chainId: 1337,
    },
  },
};

export default config;
