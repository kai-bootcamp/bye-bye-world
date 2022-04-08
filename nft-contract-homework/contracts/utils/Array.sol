//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library Array {
    

    function find(uint256[] memory list, uint256  value) public pure returns (int256){
        for(uint256 i = 0; i < list.length; i++){
            if(list[i] == value){
                return int256(i);
            }
        }
        return -1;
    }

    function removeByValue(uint256[] memory list, uint256 value) public pure {
        int256 index = find(list, value);

        if(index > 0){
            removeByIndex(list, uint256(index));
        }
    }

    function removeByIndex(uint256[] memory list, uint256 i) public pure{
        require(i < list.length - 1, "index too big");
        
        while (i < list.length - 1){
            list[i] = list[i+1];
            i++;
        }
        delete list[list.length - 1];
    }
}