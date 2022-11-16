// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

struct donarDetails{
    string name;
    uint age;
    string addrs;
    uint damount;
}

contract DonateContract {
    mapping (address => donarDetails) public accountInfo;

    function setDetails(string memory _name, uint _age, string memory _addrs, uint _damount) public {
        accountInfo[msg.sender] = donarDetails(_name, _age, _addrs, accountInfo[msg.sender].damount + _damount);
    }

    function deleteDetails() public {
        delete accountInfo[msg.sender];
    }
}