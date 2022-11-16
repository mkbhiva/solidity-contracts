// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract moneySample {

    address owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    function getMoney() public payable{

    }

    // fallback() external payable{}

    function checkContactBalance() public view returns(uint){
        return address(this).balance;
    }

    function transferToAddress() public {
        payable(owner).transfer(address(this).balance);
    }

    function checkAddressBalance() public view returns(uint){
        return owner.balance;
    }

}