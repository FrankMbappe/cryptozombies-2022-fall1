// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0 <0.9.0;

contract ZombieFactory {
  /* -- Structs -- */
  struct Zombie {
    string name;
    uint256 dna;
  }

  /* -- Variables -- */
  uint256 dnaDigits = 16;
  uint256 dnaModulus = 10 ** dnaDigits;
  Zombie[] public zombies;
  mapping(uint256 => address) public zombieToOwner;
  mapping(address => uint256) ownerZombieCount;

  /* -- Events -- */
  event NewZombie(uint256 zombieId, string name, uint256 dna);

  /* -- Functions -- */
  /**
   * @dev A private function that returns a zombie
   * @param _name The name of the zombie to be created
   * @param _dna The DNA of the zombie to be created
   */
  function _createZombie(string memory _name, uint256 _dna) private {
    zombies.push(Zombie(_name, _dna));
    uint256 id = zombies.length - 1;

    emit NewZombie(id, _name, _dna);
  }

  /**
   * @dev Creates a semi-random number and returns it
   * @param _str A string to generate the random number from
   * @return A random number
   */
  function _generateRandomDna(
    string memory _str
  ) private view returns (uint256) {
    uint256 rand = uint256(keccak256(abi.encode(_str)));

    return rand % dnaModulus;
  }

  /**
   * @dev A pbulic function to create a zombie
   * @param _name The name of the zombie
   */
  function generateRandomZombie(string memory _name) public {
    uint256 randDna = _generateRandomDna(_name);

    _createZombie(_name, randDna);
  }
}
