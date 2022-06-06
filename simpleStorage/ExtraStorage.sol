// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./SimpleStorage.sol";

// its like ExstraStorage extends SimpleStorage
contract ExstraStorage is SimpleStorage {

    // like @Override in java
    function store(uint256 _favNumber) public override {
        favoriteNumber = _favNumber + 5;
    }
}