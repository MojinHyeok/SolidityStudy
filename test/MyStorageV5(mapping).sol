// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MyStorageV5 {
    address public owner;
    mapping(address => uint256) public userNumbers;

    event NumberSet(address indexed user, uint256 number);
    event NumberAdded(address indexed user, uint256 oldNumber, uint256 newNumber);

    constructor() {
        owner = msg.sender;
    }

    modifier validNumber(uint256 _number) {
        require(_number > 0, "Number must be greater than 0");
        _;
    }

    function setMyNumber(uint256 _number) public validNumber(_number) {
        userNumbers[msg.sender] = _number;
        emit NumberSet(msg.sender, _number);
    }

    function addMyNumber(uint256 _number) public validNumber(_number) {
        uint256 oldNumber = userNumbers[msg.sender];
        userNumbers[msg.sender] = oldNumber + _number;

        emit NumberAdded(msg.sender, oldNumber, userNumbers[msg.sender]);
    }

    function getMyNumber() public view returns (uint256) {
        return userNumbers[msg.sender];
    }

    function getNumberByAddress(address _user) public view returns (uint256) {
        return userNumbers[_user];
    }
}