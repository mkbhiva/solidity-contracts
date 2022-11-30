// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract Structsample{

    enum ModeType {online, offline}

    ModeType modeType;

    struct school{
        string nameStudent;
        uint8 classStudent;
        uint8 ageStudent; 
        uint8 modeof;
    }

    mapping (uint8 =>school) mark;

    //setting details
    function setDetails(uint8 _key, string memory _name, uint8 _class, uint8 _age, uint8 _mode) public {
        mark[_key].nameStudent= _name;
        mark[_key].classStudent= _class;
        mark[_key].ageStudent=_age;
        modeType = ModeType(_mode);
        mark[_key].modeof = uint8(modeType);
    }

    //getting details
    function getDetails(uint8 _key) public view returns(string memory, uint8, uint8, uint8){
        return (
            mark[_key].nameStudent,
            mark[_key].classStudent,
            mark[_key].ageStudent,
            mark[_key].modeof
            );
    }
}