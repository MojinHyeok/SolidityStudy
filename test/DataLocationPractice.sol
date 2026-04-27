// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DataLocationPractice {

    // ========================
    // 구조체 정의
    // ========================
    struct User {
        string name;
        uint256 age;
    }

    // 사용자 정보 저장 (블록체인에 저장됨 = storage)
    mapping(address => User) public users;

    /*
    =========================================================
    constructor 설명
    =========================================================

    constructor -> 컨트랙트 배포 시 1번 실행

    역할:
    -> 초기값 세팅

    하지만 Solidity에서는 constructor 없어도 됨

    이유:
    -> 변수는 기본값으로 자동 초기화됨
       string -> ""
       uint -> 0
       bool -> false

    정리:
    -> constructor는 필수가 아니라 선택사항
    */

    // constructor 없이도 정상 동작

    /*
    =========================================================
    1. STORAGE 실습
    =========================================================
    */

    function setUserStorage(string memory _name, uint256 _age) public {

        /*
        storage -> 블록체인에 저장된 원본 데이터

        users[msg.sender] -> storage에 있음
        storage로 가져오면 참조(reference)
        */

        User storage user = users[msg.sender];

        // 원본 직접 수정
        user.name = _name;
        user.age = _age;

        /*
        결과:
        -> 실제 블록체인 데이터 변경됨
        */
    }

    /*
    =========================================================
    2. MEMORY 실습
    =========================================================
    */

    function setUserMemory(string memory _name, uint256 _age) public view{

        /*
        memory -> 임시 복사본

        storage -> memory 복사됨
        */

        User memory user = users[msg.sender];

        // 복사본 수정
        user.name = _name;
        user.age = _age;

        /*
        결과:
        -> 블록체인 데이터 변경 안됨
        -> 함수 끝나면 사라짐

        핵심:
        -> memory는 원본에 영향 없음
        */
    }

    /*
    =========================================================
    3. CALLEDATA 실습
    =========================================================
    */

    function setUserCalldata(string calldata _name, uint256 _age) external {

        /*
        calldata -> 외부 입력값

        특징:
        -> 읽기 전용
        -> 가장 가스 효율적
        */

        // _name = "kim"; -> 불가능 (에러)

        users[msg.sender] = User(_name, _age);

        /*
        결과:
        -> calldata 값을 storage에 저장
        -> 상태 변경됨
        */
    }

    /*
    =========================================================
    조회 함수
    =========================================================
    */

    function getMyUser() public view returns (string memory, uint256) {
        return (users[msg.sender].name, users[msg.sender].age);
    }

    /*
    =========================================================
    핵심 요약
    =========================================================

    storage:
    -> 블록체인에 저장된 원본
    -> 수정하면 바로 반영됨
    -> 가스 비쌈

    memory:
    -> 임시 복사본
    -> 수정해도 원본 안 바뀜
    -> 함수 끝나면 사라짐

    calldata:
    -> 외부 입력값
    -> 읽기 전용
    -> 가장 가스 효율적
    */
}