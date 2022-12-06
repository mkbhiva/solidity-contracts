// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract BankKyc {

    address RBIaddress; //0x5B38Da6a701c568545dCfcB03FcB875f56beddC4

    constructor() {
        RBIaddress = msg.sender;
    }

    modifier onlyRBI {
        require(msg.sender == RBIaddress, "Only RBI can access this function.");
        _;
    } 

    struct bankInfo {
        address bankAddress;
        string bankName;
        uint kycCount;
        bool canAddCustomer;
        bool canDoKyc;
    }

    struct customerInfo {
        string customerName;
        string customerData;
        address customerBankAddress;
        bool customerKycStatus;
    }

    mapping(address => bankInfo) bankDetails;
    mapping(string => customerInfo) customerDetails;

    function addNewBank(
        address _bankAddress, 
        string memory _bankName, 
        uint _kycCount, 
        bool _canAddCustomer, 
        bool _canDoKyc
        ) public onlyRBI {
            bankDetails[_bankAddress].bankAddress = _bankAddress;
            bankDetails[_bankAddress].bankName = _bankName;
            bankDetails[_bankAddress].kycCount = _kycCount;
            bankDetails[_bankAddress].canAddCustomer = _canAddCustomer;
            bankDetails[_bankAddress].canDoKyc = _canDoKyc;
    }

    function addNewCustomerToBank(
        string memory _customerName, 
        string memory _customerData
        ) public {
            require(bankDetails[msg.sender].canAddCustomer,  "You do not have permission to Add customer");
            customerDetails[_customerName].customerName = _customerName;
            customerDetails[_customerName].customerData = _customerData;
            customerDetails[_customerName].customerBankAddress = msg.sender;
            customerDetails[_customerName].customerKycStatus = false;
    }

    function checkKycStatus(string memory _customerName) public view returns(bool customerKycStatus) {
        return customerDetails[_customerName].customerKycStatus;
    }

    function addNewCustomerRequestForKyc(string memory _customerName, bool _customerKycStatus) public {
        require(bankDetails[msg.sender].canDoKyc,  "You do not have Permission for KYC.");
        customerDetails[_customerName].customerKycStatus = _customerKycStatus;
        address herebankAddress = customerDetails[_customerName].customerBankAddress;
        _customerKycStatus==true ? bankDetails[herebankAddress].kycCount++ : bankDetails[herebankAddress].kycCount--;
    }

    function allowBankFromAddingNewCustomers(address _bankAddress) public onlyRBI {
        bankDetails[_bankAddress].canAddCustomer = true;
    }

    function blockBankFromAddingNewCustomers(address _bankAddress) public onlyRBI {
        bankDetails[_bankAddress].canAddCustomer = false;
    }

    function allowBankForKyc(address _bankAddress) public onlyRBI {
        bankDetails[_bankAddress].canDoKyc = true;
    }

    function blockBankForKyc(address _bankAddress) public onlyRBI {
        bankDetails[_bankAddress].canDoKyc = false;
    }

    function viewCustomerData(string memory _customerName) public view returns(
        string memory customerName, 
        string memory customerData, 
        address customerBankAddress, 
        bool customerKycStatus
    ) {
        return (
            customerDetails[_customerName].customerName,
            customerDetails[_customerName].customerData,
            customerDetails[_customerName].customerBankAddress,
            customerDetails[_customerName].customerKycStatus
        );
    }

    

}