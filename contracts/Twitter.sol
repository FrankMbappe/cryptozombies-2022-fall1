// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0 <0.9.0;

contract Twitter {
  uint256 digits = 16;
  uint256 modulus = 10 ** digits;

  event NewTweet(uint256 id, address author, string text, uint256 timestamp);

  struct Tweet {
    uint256 id;
    uint256 timestamp;
    string text;
    address author;
    bool isDeleted;
  }

  mapping(uint256 => Tweet) public tweets;
  mapping(uint256 => bool) public tweetsInserted;
  uint256[] public tweetsKeys;
  uint256 deletedTweetCount = 0;

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
   * Update an existing tweet
   * @param _id ID of tweet
   * @param _text Text update
   */
  function updateTweet(uint256 _id, string memory _text) public payable {
    // Only tweet authors can update their tweets
    require(tweets[_id].author == msg.sender);

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
    require(tweets[_id].author == msg.sender);

    // Update tweet flag
    tweets[_id].isDeleted = true;

    // Increase deleted count
    deletedTweetCount++;
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
