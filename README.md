<br />
<div align="center">
  <h1>Twitter-clone Smart Contract 🦜</h1>
  <p>
    This solidity project is the backend of our Twitter clone project, made with <a href="https://hardhat.org/">Hardhat</a>.
  </p>
  <br />
</div>

<br />

## 🚀 Quickstart

Once you have clone the project, install project dependencies using the following command:

```shell
npm install
```

Create a `.env` file in the root directory and set your [Alchemy](https://www.alchemy.com/) API key and Goerli account private key values following this format:

```env
ALCHEMY_API_KEY=<YOUR ALCHEMY API KEY>
GOERLI_PRIVATE_KEY=<YOUR GOERLI API KEY>
```

Test the project using the following command:

```shell
npm run test
```

<br />

## 🌍 For deployment

Compile the project using the following command:

```shell
npm run compile
```

If you want to test the project using the [Ganache](https://trufflesuite.com/ganache/) testnet, just replace in the file [`hardhat.config.ts`](hardhat.config.ts), the first value of `accounts` array with your Ganache account private key:

```ts
  ...
},
    ganache: {
      url: "http://127.0.0.1:7545", // Default Ganache URL, replace if different
      accounts: [
        // Replace with your ganache account private key
        "<YOUR_GANACHE_ACCOUNT_PRIVATE_KEY>",
      ],
      chainId: 1337,
    },
  },
  ...
```

and deploy to Ganache using this command:

```shell
npm run devdeploy
```

To deploy on Goerli, just compile the project as shown earlier and run this command:

```shell
npm run prodeploy
```

## 🧩 Miscellaneous

To reformat the entire project files with [Prettier](https://prettier.io/), use the following command:

```shell
npm run format
```
