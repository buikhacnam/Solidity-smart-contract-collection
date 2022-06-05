// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

//import AggregatorV3Interface contract from chainlink github:https://github.dev/smartcontractkit/chainlink/tree/develop/contracts
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

//import libraries
import "./PriceConverter.sol";
// contract address: 0xe07ac59b270c849bf10291943bee42f4fae72e62
// 0xa4d4b8c1175efb05cb55ab02bfb4ee9e1729a95b
//0x072194807badD49C061B8195aEDD93576aFc0ce8
// 0x97fEa0AC2b7a702a6F8846056064446E84fA98EB

//Custom error
error NotOwner();

contract FundMe {
    // using PriceConverter for uint256; // catch it to uint256. But why?

    address public immutable i_owner;
    uint256 public constant MINIMUM_USD = 50 * 1e18; //18 zero (do this cause the value of USD will have 18 degits at the end -> make it convenient to work with Wei)
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    constructor() {
        i_owner = msg.sender;
    }

    modifier onlyOwner {
        // require(msg.sender == i_owner, "sender is not owner");
        //using custome error instead
        if(msg.sender != i_owner) {
            revert NotOwner(); // it will save us gas since we dont have to save "sender is not owener" in the contract.
        }
        _;
    }
    
    // function fund() public payable {
    //     // if to doesnt go through the require below, 
    //     //it will be reverted all the way prior to this and 
    //     //send back gas to sender up to this point
    //     require(msg.value > 1e18, "didnt send enough eth");
    //     // 1e18 == (1 * 10) ** 18 == 1000000000000000000 wei = 1eth
    // }


    function fundByUsd() public payable {
        require(getConversionRate(msg.value) > MINIMUM_USD, "didnt send enough usd");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    // function fundUsingPriceConverterLib() public payable {
    //     require(PriceConverter.getConversionRate(msg.value) > MINIMUM_USD, "didnt send enough");
    //     funders.push(msg.sender);
    //     addressToAmountFunded[msg.sender] += msg.value;
    // }

    // What happen if someone sends the contract ETH without calling the fund function?
    // the answer is to using special functions: receive and fallback
    // we play around with them in the "./FallbackExample.sol"

    receive() external payable {
        fundByUsd();
    }

    fallback() external payable {
        fundByUsd();
    }

    function convertOneEthToUsd() public view returns(uint256) {
        // we need ABI and Address
        //Address: get the address from: https://docs.chain.link/docs/ethereum-addresses/
                // and find the Rinkeby section -> ETH / USD: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        //ABI: import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
     
        (
           ,
            int256 answer,
            ,
            ,
        
        )  = priceFeed.latestRoundData();

        //answer is the value of 1ETH in usd (neglect the last 8 digits)
        // 1 ETH = answer : 1830.45744282 : 1830 usd
        // we add more 10 zeros to the end to make it the total of 18 degits attached to the end of the USD value -> it will work conveniently with Wei

        // return the USD value with the tail of total 18 degits
        return uint256(answer * 1e10); // -> 1830 457442820000000000 
    }

    function getConversionRate(uint256 weiAmount) public view returns (uint256) {
        uint256 valueOfUsdPerOneEth = convertOneEthToUsd(); // -> 1830 457442820000000000
        // uint256 ethValueFromWei = weiAmount / 1e18; // example: a generous user send 2000000000000000000 wei -> it will be converted to 2 eth
        // return ethValueFromWei * ethValueFromWei -> 2 * 1830 457442820000000000 = 3660 914885640000000000


        // but we calculate this way instead cause weiAmount / 1e18 = 0 for some reasons (check convertWeiToEth function for reference)
        // there for we have to put 18 degits of 0 at the end of MINIMUM_USD value (same numbers of 0 of Wei from Eth)
        return (valueOfUsdPerOneEth * weiAmount) / 1e18;  // -> (1830 457442820000000000 * 2000000000000000000) / 1e18 = 3660 914885640000000000

        //3660 914885640000000000 is way qualify the MINIMUM_USD which only 50 000000000000000000 usd

        //reference: 0.025 ETH will fail  but 0.03 ETH will success
    }

    function convertWeiToEth(uint256 weiAmount) public pure returns(uint256) {
        uint256 ethValueFromWei = weiAmount / 1e18;
        return ethValueFromWei;
    }

    function getVersionOfAggregatorContract() public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    function testPriceConverterLib() public pure returns(string memory) {
        return PriceConverter.returnString("first-","second-", "third");
    }

    function withDraw() public onlyOwner {
        for(uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        // get the balance of the contract
        uint256 balance = address(this).balance;

        // 3 ways to send money: Transfer, Send, Call

        // Transfer
        // catch address type to payable address and transfer to sender
        // payable(msg.sender).transfer(balance);

        // Send
        // same thing but send doesnt throw an error, so we need to revert it if the sending fails
        // bool sendSuccess = payable(msg.sender).send(balance);
        // require(sendSuccess, "send failed");

        // Call (recommended for the most part)
        (
            bool callSuccess,
            // bytes memory dataReturned
        ) = payable(msg.sender).call{value: balance}("");
        require(callSuccess, "call failed");
    }

}