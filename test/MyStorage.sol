// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MyStorage {
    mapping(address => uint256) public numbers;

    event NumberSet(address indexed user, uint256 number);
    //이벤트 정의 이벤트 이름 : NumberSet 기록할 데이터 user : 누가 저장했는지, number 어떤값을 저장했는지 
    // indexed는 DB의 인덱스의 느낌

    function setMyNumber(uint256 _number) public {
        require(_number > 0 , "number must be greater than zero");
        numbers[msg.sender] = _number;
        emit NumberSet(msg.sender, _number);
        //실제로 이벤트를 발생시키는 코드
        //log.info("user={}, number={}", user, number); 와비슷 
    }

    function getMyNumber() public view returns (uint256) {
        return numbers[msg.sender];
    }
}