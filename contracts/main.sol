//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;
import "./Database.sol";
import "./Student.sol";
import {FindArray} from "./FindArray.sol";
 
contract main {
 
    //버스들 명단
    address[] private buses;
   
    //DB
    Database DB;
    address manager;
   
   
    // 학생의 주소와 Student contract를 매핑
    mapping(address => Student) students;
 
    constructor() public {
        manager = msg.sender;
        DB = new Database();
    }
 
    // 매니저인지 확인
    modifier isManager() {
        require(msg.sender == manager, "Caller is not Manager.");
        _;
    }
 
    // 버스인지 확인
    modifier isBus() {
        bool isExisted;
        (isExisted, ) = FindArray.byAddress(msg.sender, DB.getAllBus());
 
        require(isExisted, "Caller is not Bus.");
        _;
    }
 
   
    // 학생인지 확인
    modifier isStudent() {
        bool isExisted;
        (isExisted, ) = FindArray.byAddress(msg.sender, DB.getAllStudent());
 
        require(isExisted, "Caller is not Student.");
        _;
    }
   
    // 매니저인지 버스인지 확인
    modifier isManagerBus() {
        bool isExisted;
        (isExisted, ) = FindArray.byAddress(msg.sender, DB.getAllBus());
 
        require(isExisted || msg.sender == manager, "Caller is not Manager or Professor.");
        _;
    }
 
    // 매니저인지 학생인지 버스인지 확인
    modifier isMember() {
        bool isStudentExisted;
        bool isBusExisted;
 
        (isStudentExisted, ) = FindArray.byAddress(msg.sender,DB.getAllStudent());
        (isBusExisted, ) = FindArray.byAddress(msg.sender, DB.getAllBus());
        require(isStudentExisted || isBusExisted || msg.sender == manager, "Caller is not Manager or Professor.");
        _;
    }
 
    // 버스들 명단 반환
    function getbusNums() public view returns (string[] memory)
    {
        return DB.getbusNums();
    }
 
    // 버스 이름 저장
    function addBus (address bus, string memory destination, uint start_time, string memory busnum) isManager public {
        DB.addBus(bus, destination, start_time, busnum);
    }
 
    // 버스번호를 받아 버스정보 반환
    function getBus(string memory busNum) isManager public view returns (address, string memory, uint, uint[45] memory) {
        return DB.getBus(busNum);
    }
 
    // 학생 이름 저장
    function addStudent(address student, string memory student_name, uint studentnum) isManager public {
        DB.addStudent(student, student_name, studentnum);
        students[student] = new Student();
    }
 
    // 학번을 받아 학생정보 반환
    function getStudent(uint studentNum) isManager public view returns  (address, string memory) {
        return DB.getStudent(studentNum);
    }
 
    // 예약하기 학생이름, 버스번호, 좌석 입력
    function Reservation(uint student_num, string memory busNum, uint seat) isStudent public {
        require(DB.getStudentAdress(student_num) == msg.sender, "Please write correct student number"); //본인의 학번이 아니라면 예약 할 수 없음
        require(students[msg.sender].getReservedSeat() == 0 , "You already have the reservation, please cancel the reservation and do it again"); // 예약한 버스자리가 있을시 추가 예약 불가
        DB.Reservation(student_num, busNum, seat-1);
        students[msg.sender].Reservation(busNum, seat);
    }
 
    // 예약 확인하기 좌석(학생 주소받음)
    function getReservation() isStudent public view returns (string memory, uint) {
        return students[msg.sender].getReservation();
    }
 
    // 버스 예약 초기화
    function Resetbus() isBus public returns (address, uint[45] memory){
        DB.Resetbus(msg.sender);
    }
 
 
    //예약 취소
    function cancelReservation() isStudent public {
        string memory busNum = students[msg.sender].getReservedBus();
        uint seat = students[msg.sender].getReservedSeat()-1;
        students[msg.sender].cancelReservation();
        DB.cancelReservation(busNum, seat);
    }
 
}