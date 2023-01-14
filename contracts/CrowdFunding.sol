// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract CrowdFunding{
    address[] public funders;
    mapping(address=> uint256) public addressToAmountFunded;
    uint256 public constant MINIMUM_USD = 13*1e18;
    address public immutable owner;
    AggregatorV3Interface public priceFeed;


    modifier OnlyOwner() {
        require(msg.sender == owner ,"Only owner can withdraw funds");
        _;
    }

    constructor (address priceFeedAddress){
        owner=  msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }
     

     function fund() public payable {
        require(getConversion(msg.value)>MINIMUM_USD,"Not Enouggh Eth");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender]=msg.value;

}


function withdraw() public OnlyOwner {
    address[] memory m_funders = funders;
    for (uint256 funderIndex = 0;funderIndex < m_funders.length;
    funderIndex++){
        address funder = m_funders[funderIndex];
        addressToAmountFunded[funder] = 0;

    }
    funders = new address[](0);
    (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
    require(success, "Eth Transfer Failed");

}


function getPrice()public view returns(uint256 ){
    (,int256 answer,,,)= priceFeed.latestRoundData();
    return uint256(answer*1e10);
    

}
function getConversion(uint256 ethAmount) public view
 returns(uint256) {
    uint256 ethPrice  = getPrice();
    uint256 ethAmountInUsd =   (ethAmount*ethPrice) /1e10;
    return ethAmountInUsd;

 }
receive() external payable {
    fund();
}

fallback() external payable {
    fund();
}


}
