// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleBank {

    // 사용자별 잔액 저장 (address => 금액)
    mapping(address => uint256) public balances;

    event Received(address indexed user, uint256 amount);

//     {
//       to: 컨트랙트 주소,
//      data: 함수 호출 데이터,
//      value: ETH 금액,   ← ⭐ 이게 핵심
//      from: 보내는 사람
//  } 블록체인 트랜잭션의 이미 정해진 구조. 

    // ========================
    // 입금 함수
    // ========================
    function _deposit() internal {
        // msg.value = 이 함수 호출 시 같이 보낸 ETH 금액
        // payable이 있어야 ETH를 받을 수 있음
        require(msg.value > 0, unicode"잔액이 부족합니다");
        // 사용자 잔액 증가
        balances[msg.sender] += msg.value;
    }

    function depoist() public payable {
        _deposit();
    }

    // ========================
    // 출금 함수
    // ========================
    function withdraw(uint256 amount) public {

        // 1. Checks (검증 단계)
        // 사용자의 잔액이 충분한지 확인
        require(balances[msg.sender] >= amount, unicode"잔액이 부족합니다");

        // 2. Effects (상태 변경 단계)
        //  매우 중요: 먼저 잔액 차감 (reentrancy 방어)
        balances[msg.sender] -= amount;
        // → "장부를 먼저 수정한다" 라고 이해하면 됨

        // 3. Interactions (외부 호출 단계)
        // msg.sender에게 ETH 전송
        // call은 단순 송금이 아니라 "외부 컨트랙트 코드 실행"도 포함됨
        (bool success, ) = msg.sender.call{value: amount}("");

        /*
         여기서 중요한 개념

        msg.sender.call{value: amount}("")

        의미:
        - msg.sender 주소로 amount 만큼 ETH 전송
        - 만약 msg.sender가 컨트랙트라면:
            → receive() 또는 fallback() 함수 실행됨

         즉, "돈 보내면서 상대 코드 실행"까지 같이 일어남

         그래서 reentrancy 공격 가능
        */

        // 전송 실패 시 트랜잭션 전체 롤백
        require(success, unicode"ETH 전송 실패");
    }

    // ========================
    // 컨트랙트 전체 잔액 조회
    // ========================
    function getContractBalance() public view returns (uint256) {
        // address(this) = 현재 컨트랙트 주소
        // balance = 이 컨트랙트가 가지고 있는 총 ETH
        return address(this).balance;
    }
    // ========================
    // receive: ETH만 보내도 입금 처리
    // ========================
    receive() external payable {
        emit Received(msg.sender, msg.value);
        _deposit();
    }

    // ========================
    // fallback: 잘못된 호출 방지
    // ========================
    fallback() external payable {
        revert("Invalid function call");
    }
}