import { ethers } from "hardhat";

import { expect } from "chai";

describe("Twitter contract", function () {
  async function getToken() {
    const Twitter = await ethers.getContractFactory("Twitter");
    const token = await Twitter.deploy();
    return token;
  }

  it("Should create new tweet", async function () {
    const token = await getToken();

    // Init tweet
    const tweet = "John";

    // Create tweet
    await token.createTweet(tweet);

    // Expect first tweet to be our tweet
    const tweets = await token.getTweets();
    expect(tweets[0].text).to.equal(tweet);
  });

  it("Should read tweets", async function () {
    const token = await getToken();

    // Init tweet
    const tweet1 = "John";
    const tweet2 = "Jane";

    // Create tweet
    await token.createTweet(tweet1);
    await token.createTweet(tweet2);

    // Get tweets
    const tweets = await token.getTweets();

    expect(tweets.length).to.equal(2);
    expect(tweets[0].text).to.oneOf([tweet1, tweet2]);
    expect(tweets[1].text).to.oneOf([tweet1, tweet2]);
  });

  it("Should update tweet", async function () {
    const token = await getToken();

    // Init tweet
    const tweet = "John";
    const tweetUpdate = "Jane";

    // Create tweet
    await token.createTweet(tweet);

    // Get tweet to update
    const tweets = await token.getTweets();
    const tweetToUpdateId = tweets[0].id;

    // Update tweet
    await token.updateTweet(tweetToUpdateId, tweetUpdate);
    const updatedTweets = await token.getTweets();

    expect(updatedTweets[0].text).to.equal(tweetUpdate);
  });

  it("Should delete tweet", async function () {
    const token = await getToken();

    // Init tweet
    const tweet = "John";

    // Create tweet
    await token.createTweet(tweet);

    // Get tweet to delete
    const tweets = await token.getTweets();
    const tweetToDeleteId = tweets[0].id;

    // Update tweet
    await token.deleteTweet(tweetToDeleteId);
    const updatedTweets = await token.getTweets();

    expect(updatedTweets).to.be.empty;
  });
});
