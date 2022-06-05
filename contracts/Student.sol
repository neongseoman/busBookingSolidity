//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;
 
import "./Database.sol";
import {FindArray} from "./FindArray.sol";
 
/**
 * @title Student
 * @dev Student reservation storage
 */
 
contract Student {
 
    Database DB;
 
    struct reservation {
        string busNum;
        uint seat_num;
    }
 
    mapping(address => reservation) public reserv;
 
    //예약
    function Reservation(string memory busNum, uint seat) public {
        reserv[msg.sender] = reservation(busNum, seat);
    }
 
    //예약 상황 확인
    function getReservation() public view returns (string memory, uint) {
        string memory bus = reserv[msg.sender].busNum;
        uint SeatNum = reserv[msg.sender].seat_num;
        return(bus, SeatNum);
    }
 
     //예약 버스 확인
    function getReservedBus() public view returns (string memory) {
        string memory bus = reserv[msg.sender].busNum;
        return(bus);
    }
 
    //예약 상황 확인
    function getReservedSeat() public view returns (uint) {
        uint SeatNum = reserv[msg.sender].seat_num;
        return(SeatNum);
    }
 
 
    //예약 취소
    function cancelReservation() public {
        require(bytes(reserv[msg.sender].busNum).length != 0, "There is no reservation"); //예약이 없다면 취소가 되지 않음
        delete reserv[msg.sender].busNum;
        delete reserv[msg.sender].seat_num;
    }
}
