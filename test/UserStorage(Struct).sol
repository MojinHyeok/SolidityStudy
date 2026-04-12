// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UserStorage {

    struct User {
        string name;
        uint256 age;
        uint256 score;
    }

    mapping(address => User) public users;
    mapping(address => bool) public isUser;
    address[] public userList;

    event UserRegistered(address indexed user, string name, uint256 age);
    event ScoreUpdated(address indexed user, uint256 oldScore, uint256 newScore);

    // 등록된 유저만
    modifier onlyRegistered() {
        require(isUser[msg.sender], "Not registered");
        _;
    }

    //  아직 등록 안된 유저만
    modifier notRegistered() {
        require(!isUser[msg.sender], "Already registered");
        _;
    }

    function register(string memory _name, uint256 _age) public notRegistered {
        users[msg.sender] = User(_name, _age, 0);
        isUser[msg.sender] = true;
        userList.push(msg.sender);

        emit UserRegistered(msg.sender, _name, _age);
    }

    function updateScore(uint256 _score) public onlyRegistered {
        uint256 oldScore = users[msg.sender].score;
        users[msg.sender].score = _score;

        emit ScoreUpdated(msg.sender, oldScore, _score);
    }

    function getMyInfo() public view onlyRegistered returns (string memory, uint256, uint256) {
        User memory user = users[msg.sender];
        return (user.name, user.age, user.score);
    }

    function getUser(address _user) public view returns (string memory, uint256, uint256) {
        User memory user = users[_user];
        return (user.name, user.age, user.score);
    }
}