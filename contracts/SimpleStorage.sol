// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract SimpleStorage {

    uint256 favoriteNumber;

    struct People {
        uint favNumber;
        string name;
    }

    mapping(string => uint) public nameToFavNumber;

    People[] public people;


    function addPerson(string memory _name, uint _favNumber) public {
        People memory newPeople = People(_favNumber, _name);
        people.push(newPeople);
        nameToFavNumber[_name] = _favNumber;
    }

    // virtual means function store can be overided 
    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
    }
    
    function retrieve() public view returns (uint256){
        return favoriteNumber;
    }
}

// deployed contract: 0xff59e6480262e82156262fcbd118c127e8c3c9b2

//calldata: temporary storage like memory but the variable cannot be modified
