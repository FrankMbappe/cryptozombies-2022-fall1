import { ethers } from "hardhat";

import { expect } from "chai";

describe("Twitter contract", function () {
  it("Should create a new tweet", async function () {
    const Twitter = await ethers.getContractFactory("Twitter");

    const hardhatToken = await Twitter.deploy();

    await hardhatToken.createTweet("John Doe");
    console.log(await hardhatToken.tweets(10));
    expect((await hardhatToken.tweets(10)).length).to.equal(1);
  });
});
