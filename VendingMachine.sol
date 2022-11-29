// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;


contract VendingMachine {
    
    //Define state variables
    address public owner;

    mapping(address => uint) public donutBalances;

    constructor() {
        //Set the owner as the address that deploy the contract
        owner = msg.sender;
        //Set the intial donut balance to the vending machine
        donutBalances[address(this)] = 100;
    }

    
    // To get the Balance of Donut from Vending Machine
    function getVendorMachineBalance() public view returns(uint) {
        return donutBalances[address(this)];
    }

    // Let the ownder restock the vending machine
    function restock(uint _amount) public {
        require(msg.sender == owner, "Only the owner can restock the vending machine.");
        donutBalances[address(this)]+=_amount;
    }

    // Purchase Donut from the vending machine
    function purchase(uint _amount) public payable {
        // To pay some Ether for each donut
        require(msg.value >= 2 ether, "You must pay 2 Ether for the each donut");
        // To check the stock availablity
        require(donutBalances[address(this)] >= _amount, "Not enough donut in the stock to complete this purchase.");
        // Deduct the amount from machine balance
        donutBalances[address(this)]-= _amount;
        // Add the amount of donut to Buyer
        donutBalances[msg.sender] += _amount;
    }


}

