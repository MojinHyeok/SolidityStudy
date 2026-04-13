// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleBank {

    mapping(address => uint256) public balances;

    function deposit() public payable {
        require(msg.value > 0, "Send ETH");

        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Not enough balance");

        balances[msg.sender] -= amount;
        //장부수정

        (bool success, ) = msg.sender.call{value: amount}("");
        //돈보낸다~
        //msg.sender 주소로 eth를 보내면서 , 동시에 주소의 코드를 실행할 수 도있는 저수준 호출.
        //이 주소한테 돈 보내면서 함수 실행 요청까지 같이 하는 느낌.
        require(success, "Transfer failed");
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}