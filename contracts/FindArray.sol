//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0;

/*
 * @title FindArray
 * @dev String, address 타입의 배열에서 특정 요소 탐색. 존재하면 true, 해당 인덱스 반환, 없다면 false, 0 반환
 */
library FindArray{
// 주소 배열에서 특정 주소를 탐색.
    function byAddress(address _target, address[] memory _array) internal pure returns (bool, uint) {
        bool isExisted = false;
        uint index = 0;
   
        for(uint i=0; i < _array.length; i++){
            if (_array[i] == _target){
                (isExisted, index) = (true, i);
                break;
                }
            }
            return (isExisted, index);
    }
 
// 주소 배열에서 특정 주소를 탐색.
    function byString(string memory _target, string[] memory _array) internal pure returns (bool, uint) {
        bool isExisted = false;
        uint index = 0;
       
        for(uint i=0; i < _array.length; i++){
            if (keccak256(abi.encodePacked(_array[i])) == keccak256(abi.encodePacked(_target))){
                (isExisted, index) = (true, i);
                break;
            }
        }
        return (isExisted, index);
    }
}
