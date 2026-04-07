// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MyStorageV2 {
    uint256 public myNumber;
    //public이기 떄문에 getter는 자동으로 생성된다.
    address public owner;

    constructor(uint256 _initialNumber) {
        myNumber = _initialNumber;
        owner = msg.sender;
    }

    function setMyNumber(uint256 _number) public {
        myNumber = _number;
    }

    function addNumber(uint256 _number) public {
        myNumber = myNumber + _number;
    }

    function getMyNumber() public view returns (uint256) {
        return myNumber;
    }

    function getDoubleNumber() public view returns (uint256) {
        return myNumber * 2;
    }

    function addTwoNumbers(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }
    //view = 상태 읽기 가능, 수정 불가
    //pure = 상태 읽기도 불가, 수정도 불가
}