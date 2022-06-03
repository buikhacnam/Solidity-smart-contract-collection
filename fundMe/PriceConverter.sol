// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// library is like a Class with static methods having no state / variable
library PriceConverter {

    function convertOneEthToUsd() internal view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
     
        (
           ,
            int256 answer,
            ,
            ,
        
        )  = priceFeed.latestRoundData();
        return uint256(answer * 1e10); 
    }

    function getConversionRate(uint256 weiAmount) internal view returns (uint256) {
        uint256 valueOfUsdPerOneEth = convertOneEthToUsd(); 
       
        return (valueOfUsdPerOneEth * weiAmount) / 1e18;  
    }

    function convertWeiToEth(uint256 weiAmount) internal pure returns(uint256) {
        uint256 ethValueFromWei = weiAmount / 1e18;
        return ethValueFromWei;
    }

    function getVersionOfAggregatorContract() internal view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    function returnString(string memory a, string memory b, string memory c) internal pure returns(string memory) {
       return string(abi.encodePacked(a, b, c));
    }
}