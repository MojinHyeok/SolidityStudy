// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MyStorageV3 {
    uint256 public myNumber;
    address public owner;

    constructor(uint256 _initialNumber) {
        myNumber = _initialNumber;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    modifier validNumber(uint256 _number) {
        require(_number > 0, "Number must be greater than 0");
        _;
    }

    function setMyNumber(uint256 _number) public onlyOwner validNumber(_number) {
        myNumber = _number;
    }

    function addNumber(uint256 _number) public onlyOwner validNumber(_number) {
        myNumber = myNumber + _number;
    }

    function resetNumber() public onlyOwner {
        myNumber = 1;
    }
}