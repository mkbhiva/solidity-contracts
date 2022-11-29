//SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

contract DecentralizedHospital {
    address hospitalAdmin;
    uint256 public totalNoOfPatient;
    uint256 public totalAdmittedPatient;

    constructor() {
        hospitalAdmin = msg.sender;
    }

    modifier onlyAdmin() {
        require (msg.sender == hospitalAdmin);
        _;
    }

    struct Patient {
        string name;
        string paddress;
        string disease;
        bool stillAdmitted;
        string department;
    }

    mapping(string => mapping(address => Patient)) patientRecord;

    function addPatient(
        address _address, 
        string memory _name,
        string memory _paddress,
        string memory _disease,
        string memory _department
        ) public onlyAdmin {

            patientRecord[_department][_address].name = _name;
            patientRecord[_department][_address].paddress = _paddress;
            patientRecord[_department][_address].disease = _disease;
            patientRecord[_department][_address].stillAdmitted = true;
            patientRecord[_department][_address].department = _department;

            totalNoOfPatient++;
            totalAdmittedPatient++;
    }

    function queryPatient(address _address, string memory _department) public view returns(
        string memory,
        string memory,
        string memory,
        string memory,
        bool
    ) {

        return(
            patientRecord[_department][_address].name,
            patientRecord[_department][_address].paddress,
            patientRecord[_department][_address].disease,
            patientRecord[_department][_address].department,
            patientRecord[_department][_address].stillAdmitted
        );

    }

    function isAdmitted(address _address, string memory _department) public view returns(bool){
        return patientRecord[_department][_address].stillAdmitted;
    }

    function dischargePatient(address _address, string memory _department) public {
        patientRecord[_department][_address].stillAdmitted = false;
        totalAdmittedPatient = totalAdmittedPatient-1;
    }


}