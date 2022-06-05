// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

contract FallbackExample {
    uint256 public result;

    // whenever we send ETH or make a transaction to the contract
    // as long as no data associate with the transaction
    // the receive() will be trigger
    receive() external payable {
        result = 1;
    }
    // to test receive() :send the contract EHT by using Low Level Transactions in Remix without any data:


    // fallback() will be both triggered either with or without data associated with the transaction.
    // but when there is a receive() function in the contract, transaction without data will always call receive()
    // see the chart below for details
    fallback() external payable {
        result = 2;
    }
    // to test fallback() with data just type in 0x00



    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()
}