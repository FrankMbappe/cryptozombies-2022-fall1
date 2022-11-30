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

  it("Should not update tweet if user is not author", async function () {
    const token = await getToken();
    const [_, someoneElse] = await ethers.getSigners();

    // Init tweet
    const tweet = "John";
    const tweetUpdate = "Jane";

    // Create tweet
    await token.createTweet(tweet);

    // Get tweet to update
    const tweets = await token.getTweets();
    const tweetToUpdateId = tweets[0].id;

    // Update tweet while connecting as someone else
    await expect(
      token.connect(someoneElse).updateTweet(tweetToUpdateId, tweetUpdate),
    ).to.be.revertedWith("Only author can update tweet");
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

    // Delete tweet
    await token.deleteTweet(tweetToDeleteId);
    const updatedTweets = await token.getTweets();

    expect(updatedTweets).to.be.empty;
  });

  it("Should not delete tweet if user is not author", async function () {
    const token = await getToken();
    const [_, someoneElse] = await ethers.getSigners();

    // Init tweet
    const tweet = "John";

    // Create tweet
    await token.createTweet(tweet);

    // Get tweet to delete
    const tweets = await token.getTweets();
    const tweetToDeleteId = tweets[0].id;

    // Delete tweet while connecting as someone else
    await expect(
      token.connect(someoneElse).deleteTweet(tweetToDeleteId),
    ).to.be.revertedWith("Only author can delete tweet");
  });

  it("Should like a tweet", async function () {
    const token = await getToken();
    const [owner] = await ethers.getSigners();

    // Init tweet
    const tweet = "John Doe";

    // Create tweet
    await token.createTweet(tweet);

    // Get tweet to delete
    const tweets = await token.getTweets();
    const tweetToLikeId = tweets[0].id;

    // Like tweet
    await token.toggleLikeTweet(tweetToLikeId);

    const updatedTweets = await token.getTweetsWithLikes();
    expect(updatedTweets[0].tweet.likesCount).to.equal(1); // Should be liked once
    expect(updatedTweets[0].likedBy).to.contain(owner.address); // Should contain owner's address among likers
  });

  it("Should dislike a tweet", async function () {
    const token = await getToken();
    const [owner] = await ethers.getSigners();

    // Init tweet
    const tweet = "John Doe";

    // Create tweet
    await token.createTweet(tweet);

    // Get tweet to delete
    const tweets = await token.getTweets();
    const tweetToLikeId = tweets[0].id;

    // Like tweet
    await token.toggleLikeTweet(tweetToLikeId);

    // Dislike tweet
    await token.toggleLikeTweet(tweetToLikeId);

    const updatedTweets = await token.getTweetsWithLikes();
    expect(updatedTweets[0].tweet.likesCount).to.equal(0); // Should have no likes
    expect(updatedTweets[0].likedBy).not.to.contain(owner.address); // Should not contain owner's address among likers
  });
});
