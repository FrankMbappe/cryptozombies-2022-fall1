// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0 <0.9.0;

import "hardhat/console.sol";

contract Twitter {
  uint256 digits = 16;
  uint256 modulus = 10 ** digits;

  event NewTweet(uint256 id, address author, string text, uint256 timestamp);
  event NewTweetLike(
    uint256 id,
    address author,
    bool hasLiked,
    uint256 timestamp
  );

  struct Tweet {
    uint256 id;
    uint256 timestamp;
    string text;
    address author;
    uint256 likesCount;
    bool isDeleted;
  }
  struct TweetWithLikes {
    Tweet tweet;
    address[] likedBy;
  }

  mapping(uint256 => Tweet) tweets;
  mapping(uint256 => bool) tweetsInserted;
  uint256[] tweetsKeys;
  uint256 deletedTweetCount = 0;

  mapping(uint256 => address[]) tweetLikers;

  /**
   * Creates a new tweet
   * @param _text The text of the tweet
   */
  function createTweet(string memory _text) public payable {
    // No empty string
    require(keccak256(bytes(_text)) != keccak256(bytes("")));

    // Generate an ID
    uint256 generatedId = _generateRandomId(_text);

    // Setup tweet struct
    Tweet memory tweet = Tweet(
      generatedId, // id
      block.timestamp, // timestamp
      _text, // text
      msg.sender, // author
      0, // likes
      false // is deleted?
    );

    // Add tweet to the mapping
    tweets[tweet.id] = tweet;

    // Keep track of inserted keys
    if (!tweetsInserted[tweet.id]) {
      tweetsInserted[tweet.id] = true;
      tweetsKeys.push(tweet.id);
    }

    // Emit new tweet event
    emit NewTweet(tweet.id, tweet.author, tweet.text, tweet.timestamp);
  }

  /**
   * Get the number of non-deleted tweets
   * @return The number of tweets
   */
  function getTweetCount() external view returns (uint256) {
    return tweetsKeys.length - deletedTweetCount;
  }

  /**
   * Get the list of non-deleted tweets
   * @return An array of tweets
   */
  function getTweets() external view returns (Tweet[] memory) {
    Tweet[] memory nonDeletedTweets = new Tweet[](
      tweetsKeys.length - deletedTweetCount
    );
    uint j = 0;

    for (uint i = 0; i < tweetsKeys.length; i++) {
      Tweet memory t = tweets[tweetsKeys[i]];
      // Select non-deleted tweets only
      if (!t.isDeleted) {
        nonDeletedTweets[j] = t;
        j++;
      }
    }

    return nonDeletedTweets;
  }

  /**
   * Get the list of non-deleted tweets with likes
   * @return An array of tweets with likes
   */
  function getTweetsWithLikes()
    external
    view
    returns (TweetWithLikes[] memory)
  {
    TweetWithLikes[] memory nonDeletedTweetsWithLikes = new TweetWithLikes[](
      tweetsKeys.length - deletedTweetCount
    );
    uint j = 0;

    for (uint i = 0; i < tweetsKeys.length; i++) {
      Tweet memory tweet = tweets[tweetsKeys[i]];
      // Select non-deleted tweets only
      if (!tweet.isDeleted) {
        nonDeletedTweetsWithLikes[j] = TweetWithLikes(
          tweet,
          tweetLikers[tweet.id]
        );
        j++;
      }
    }

    return nonDeletedTweetsWithLikes;
  }

  /**
   * Update an existing tweet
   * @param _id ID of tweet
   * @param _text Text update
   */
  function updateTweet(uint256 _id, string memory _text) public payable {
    // Only tweet authors can update their tweets
    require(tweets[_id].author == msg.sender, "Only author can update tweet");

    // No empty string
    require(keccak256(bytes(_text)) != keccak256(bytes("")));

    // Update tweet
    tweets[_id].text = _text;
  }

  /**
   * Delete an existing tweet
   * @param _id ID of tweet
   */
  function deleteTweet(uint256 _id) public payable {
    // Only tweet authors can delete their tweets
    require(tweets[_id].author == msg.sender, "Only author can delete tweet");

    // Update tweet flag
    tweets[_id].isDeleted = true;

    // Increase deleted count
    deletedTweetCount++;
  }

  /**
   * Like or dislike a tweet, depending on if user has liked it already or not
   * @param _id ID of tweet
   */
  function toggleLikeTweet(uint256 _id) public payable {
    // Get address list of those who liked the tweet
    address[] memory likers = tweetLikers[_id];

    // Find out if user address is in likers array
    for (uint i = 0; i < likers.length; i++) {
      // If user has already liked
      if (likers[i] == msg.sender) {
        delete tweetLikers[_id][i]; // Remove user from likers

        // Decrement like count of tweet
        if (tweets[_id].likesCount > 0) tweets[_id].likesCount--;

        emit NewTweetLike(_id, msg.sender, false, block.timestamp); // Emit tweet dislike event

        return; // Stop function
      }
    }

    // If we reach this stage, it means user hasn't liked yet
    tweetLikers[_id].push(msg.sender); // Add user address to tweet likers

    tweets[_id].likesCount++; // Increment like count of tweet

    emit NewTweetLike(_id, msg.sender, true, block.timestamp); // Emit tweet like event
  }

  /**
   * Generate a random number
   * @param _str String from which the number will be determined
   * @return A random uint256
   */
  function _generateRandomId(
    string memory _str
  ) private view returns (uint256) {
    uint rand = uint(keccak256(abi.encodePacked(_str)));
    return rand % modulus;
  }
}
