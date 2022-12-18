// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract BankKyc {

    address RBIaddress; //0x5B38Da6a701c568545dCfcB03FcB875f56beddC4

    constructor() {
        RBIaddress = msg.sender;
    }

    struct bankInfo {
        address bankAddress;
        string bankName;
        uint kycCount;
        bool canAddCustomer; //true false 
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

    modifier onlyRBI {
        require(msg.sender == RBIaddress, "Only RBI can access this function.");
        _;
    } 

    modifier onlyBank {
        require(bankDetails[msg.sender].bankAddress == msg.sender, "Only Bank can access this function.");
        _;
    } 

    // Only RBI can add a new Bank
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

    // Only Bank can add the customer who has the access to add customer.
    function addNewCustomerToBank(
        string memory _customerName, 
        string memory _customerData
        ) public onlyBank {
            require(bankDetails[msg.sender].canAddCustomer,  "You do not have permission to Add customer");
            customerDetails[_customerName].customerName = _customerName;
            customerDetails[_customerName].customerData = _customerData;
            customerDetails[_customerName].customerBankAddress = msg.sender;
            customerDetails[_customerName].customerKycStatus = false;  // Inititally the customer has KYC status as a false means not verified
    }

    // Anybody can check the status of a customer
    function checkKycStatus(string memory _customerName) public view returns(bool customerKycStatus) {
        return customerDetails[_customerName].customerKycStatus;
    }

    // Only Bank can update the status of KYC of a customer who have permission from RBI
    function addNewCustomerRequestForKyc(string memory _customerName, bool _customerKycStatus) public onlyBank {
        require(bankDetails[msg.sender].canDoKyc,  "You do not have Permission for KYC.");
        require(customerDetails[_customerName].customerBankAddress == msg.sender,  "This customer is not asscociated with you. Can not do KYC update for this customer.");
        customerDetails[_customerName].customerKycStatus = _customerKycStatus;
        address herebankAddress = customerDetails[_customerName].customerBankAddress;
        // Checking if KYC status is verified then adding one count to the bank otherwise its deducted one
        _customerKycStatus==true ? bankDetails[herebankAddress].kycCount++ : bankDetails[herebankAddress].kycCount--;
    }

    // Only RBI can give the access to the Bank to add New customers
    function allowBankFromAddingNewCustomers(address _bankAddress) public onlyRBI {
        bankDetails[_bankAddress].canAddCustomer = true;
    }

    // Only RBI can Block the Bank to add new customer to the Bank
    function blockBankFromAddingNewCustomers(address _bankAddress) public onlyRBI {
        bankDetails[_bankAddress].canAddCustomer = false;
    }

    // Only RBI can give the permission to the Bank for KYC verification
    function allowBankForKyc(address _bankAddress) public onlyRBI {
        bankDetails[_bankAddress].canDoKyc = true;
    }

    // Only RBI can block the permission to the Bank to KYC verification
    function blockBankForKyc(address _bankAddress) public onlyRBI {
        bankDetails[_bankAddress].canDoKyc = false;
    }

    // Anyone can access to get customer details
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