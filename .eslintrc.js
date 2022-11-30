module.exports = {
  root: true,
  parser: "@babel/eslint-parser",
  plugins: ["prettier"],
  extends: ["eslint:recommended", "plugin:prettier/recommended"],
  parserOptions: {
    ecmaVersion: 2017,
    requireConfigFile: false,
  },
  env: {
    node: true,
    mocha: true,
  },
  rules: {
    "prettier/prettier": 0,
  },
};
