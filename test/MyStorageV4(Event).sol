// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MyStorageV4 {
    uint256 public myNumber;
    address public owner;
    //event  중요한 행동 기록을 로그로 남기는 기능
    event NumberChanged(address indexed changedBy, uint256 oldNumber, uint256 newNumber);
    event NumberReset(address indexed resetBy, uint256 resetNumber);

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
        uint256 oldNumber = myNumber;
        myNumber = _number;
        //event선언 끝이 아니라, 기록을 남기려면 emit을 써야함.
        emit NumberChanged(msg.sender, oldNumber, _number);
    }

    function addNumber(uint256 _number) public onlyOwner validNumber(_number) {
        uint256 oldNumber = myNumber;
        myNumber = myNumber + _number;

        emit NumberChanged(msg.sender, oldNumber, myNumber);
    }

    function resetNumber() public onlyOwner {
        myNumber = 1;

        emit NumberReset(msg.sender, myNumber);
    }
}