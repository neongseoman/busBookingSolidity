//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;
 
 
/**
 * @title Database
 * @dev Save Database
 */
 
contract Database{
 
    struct Student_DB{
        string student_name;
        address student;
    }
 
    struct Bus_DB{
        address bus;
        string destination;
        uint start_time;
        uint[45] Seat_number;
    }
 
    //관리자
    address private manager;
    //버스 명단
    address[] private buses;
    //학생들 명단
    address[] private students;
    //버스 번호
    string[] private busNum;
    //학생 학번
    uint[] private studentNum;
 
    constructor() public {
        manager = msg.sender;
    }
   
    mapping(string => Bus_DB) BusDB;
 
    mapping(uint => Student_DB) StudentDB;
 
    function getbusNums() public view returns (string[] memory)
    {
        return busNum;
    }
 
    function addStudent(address student, string memory student_name, uint studentnum) public {
       studentNum.push(studentnum);
       students.push(student);
       StudentDB[studentnum] = Student_DB(student_name, student);
    }
 
    //학생 번호 입력시 학생 주소 출력
    function getStudentAdress(uint studentNum) public view returns (address) {
         address student = StudentDB[studentNum].student;
         return(student);
    }
 
    function getAllStudent() public view returns (address[] memory){
        return students;
    }
 
    //학생 번호 입력시 학생 주소, 학생이름 출력
    function getStudent(uint studentNum) public view returns (address, string memory) {
         address student = StudentDB[studentNum].student;
         string memory student_name = StudentDB[studentNum].student_name;
         return(student, student_name);
    }
 
 
    function addBus(address bus, string memory destination, uint start_time, string memory busnum) public {
      uint[45] memory seat;
      delete seat;
      buses.push(bus);
      busNum.push(busnum);
      BusDB[busnum] = Bus_DB(bus, destination, start_time, seat);
    }
 
    function getAllBus() public view returns (address[] memory)
    {
        return buses;
    }
 
    //버스이름 입력시 버스 주소, 도착지, 출발시간, 예약상태 출력
    function getBus(string memory busNum) public view returns (address, string memory, uint, uint[45] memory) {
         address Bus = BusDB[busNum].bus;
         string memory destination = BusDB[busNum].destination;
         uint start_time=BusDB[busNum].start_time;
         uint[45] memory Seat = BusDB[busNum].Seat_number;
         return(Bus, destination, start_time, Seat);
    }
 
    // 학생명단에서 학생제거
    function deleteStudent(uint student_Num) public returns(string memory){
       require(bytes(StudentDB[student_Num].student_name).length != 0, "There is no Student"); // 학생 학번이 없으면 삭제를 실행하지 않음.
       delete StudentDB[student_Num]; // 학생 학번 넣으면 삭제.
       for(uint i=0; i<studentNum.length; i++) {
           if (studentNum[i]==student_Num) {
               delete studentNum[i];
               delete students[i];
           }
       }
       return "Delete success"; // 성공적으로 삭제하면 알려줌.
   }
 
 
    // 버스명단에서 버스제거
    function deleteBus(string memory BusNum) public returns(string memory){
       require(bytes(BusDB[BusNum].destination).length != 0, "There is no BUS"); // 버스 번호가 없으면 삭제를 실행하지 않음.
       delete BusDB[BusNum]; // 버스번호 넣으면 삭제.
       for(uint i=0; i<busNum.length; i++) {
           string memory tmp = busNum[i];
           if (stringsEquals(tmp,BusNum)) {
               delete busNum[i];
               delete buses[i];
           }
       }
       return "Delete success"; // 성공적으로 삭제하면 알려줌.
   }
 
 
    //memory stirng 비교
    function stringsEquals(string memory s1, string memory s2) private pure returns (bool) {
        bytes memory b1 = bytes(s1);
        bytes memory b2 = bytes(s2);
        uint256 l1 = b1.length;
        if (l1 != b2.length) return false;
            for (uint256 i=0; i<l1; i++) {
                if (b1[i] != b2[i]) return false;
            }
        return true;
    }
 
    // 예약
    function Reservation(uint studentNum, string memory busNum, uint seat) public returns (string memory){
        require(bytes(BusDB[busNum].destination).length != 0, "There is no BUS"); //버스가 없다면 예약 되지 않음
        require(BusDB[busNum].Seat_number[seat] == 0, "It's already reserved"); //이미 예약된 자리라면 예약 할 수 없음
        BusDB[busNum].Seat_number[seat] = studentNum;
        return "Reservation success";
    } 
 
    //버스 자리 예약 취소
    function cancelReservation(string memory busNum, uint seat) public {
        delete BusDB[busNum].Seat_number[seat];
    }
 
    //버스기사가 버스 출발 후 초기화
    function Resetbus(address _bus) public returns (address, uint[45] memory){
 
        for (uint i=0; i<busNum.length; i++)
        {
            if (BusDB[busNum[i]].bus == _bus)
            {
                delete BusDB[busNum[i]].Seat_number;
                return (BusDB[busNum[i]].bus, BusDB[busNum[i]].Seat_number);
            }
        }
    }
}
