 
//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;
 

 contract Bus{

     struct seat{
         uint seatNum;
         uint studentId;
         address student;
     }

     address[] private student;
     uint256 busNum;
     string destination;

     constructor(uint _num, string memory _destination){
         busNum = _num;
         destination = _destination;
         student.push(msg.sender);
     }

    mapping(uint => seat) private busSeat;

    function reservationBus(uint _seatNum, uint _studentId, address _student) public{
        busSeat[_seatNum] = seat(_seatNum, _studentId, _student);
    }
    
    function getSeatDetail(uint _num) public view returns(seat memory){
        return(busSeat[_num]);
    }

    function getBusInfo() public view returns(uint, string memory){
        return(busNum, destination);
    }

 }