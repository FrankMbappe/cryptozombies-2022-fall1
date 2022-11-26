// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0 <0.9.0;

import "./ZombieFactory.sol";

contract ZombieFeeding is ZombieFactory {
  // function feedAndMultiply(uint256 _zombieId, uint256 _targetDna) public {
  //   require(
  //     msg.sender == zombieToOwner[_zombieId],
  //     "You must own the zombie to feed it"
  //   );
  //   Zombie storage myZombie = zombies[_zombieId];
  //   _targetDna = _targetDna % dnaModulus;
  // }
}
