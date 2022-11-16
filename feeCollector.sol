// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract feeCollector {
    address public owner;
    uint256 public balance;

    constructor(){
        owner = msg.sender;
    }

    receive() payable external {
        balance += msg.value;
    }

    function withdrawal(uint amount, address payable destAddress) public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(amount <= balance, "Insufficiant funds!");
        destAddress.transfer(amount);
        balance -= amount;
    }

}
