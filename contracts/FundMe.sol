//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    address payable owner;
    mapping(address => uint256) public addresstoAmount;
    address[] public funders;
    AggregatorV3Interface public priceFeed;

    constructor(address _pricefeed) {
        priceFeed = AggregatorV3Interface(_pricefeed);
        owner = payable(msg.sender);
    }

    function pay() public payable {
        uint256 minimumUSD = 50;
        require(convert(msg.value) >= minimumUSD, "Pay UP");
        addresstoAmount[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer);
    }

    function getDecimal() public view returns (uint8) {
        return priceFeed.decimals();
    }

    function convert(uint256 _weiamount) public view returns (uint256) {
        uint256 eth_price = getPrice() / 100000000;
        uint256 ETHinUSD = (_weiamount * eth_price) / 1000000000000000000;
        return ETHinUSD;
    }

    function get_entrance_fee() public view returns (uint256) {
        uint256 minimumUSD = 50 * 10**18;
        uint256 precision = 1 * 10**8;
        uint256 price = getPrice();
        return (minimumUSD * precision) / price;
    }

    function withdraw() public payable {
        require(msg.sender == owner);
        payable(msg.sender).transfer(address(this).balance);
        for (
            uint256 fundersIndex = 0;
            fundersIndex < funders.length;
            fundersIndex++
        ) {
            address funder = funders[fundersIndex];
            addresstoAmount[funder] = 0;
        }
        funders = new address[](0);
    }

    function isBool() public view returns (bool) {
        uint256 eth_price = getPrice();
        uint256 ETHinUSD = eth_price / 10000000000;
        uint256 minimumUSD = 50;
        bool higher;
        higher = (minimumUSD >= ETHinUSD);
        return higher;
    }
}
