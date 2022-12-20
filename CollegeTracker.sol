// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract CollegeTracker {

    address unversityAdmin;

    // At the time of Deploy of this contract, address will be University Admin
    constructor() {
        unversityAdmin = msg.sender;
    }

    struct collegeInfo {
        string collegeName;
        address collegeAddress;
        uint collegeRegNo;
        bool toAddStudents; //true false 
        uint noOfStudents;
    }

    struct studentInfo {
        address collAddress;
        string studentName;
        uint256 studentPhoneNo;
        string courseEnrolled;
    }

    mapping (address => collegeInfo) collegeDetails;
    mapping (string => studentInfo) studentDetails;

    modifier onlyAdmin {
        require(msg.sender == unversityAdmin, "Only University Admin can access this function.");
        _;
    } 

    modifier onlyCollege {
        require(collegeDetails[msg.sender].collegeAddress == msg.sender, "Only College can access this function.");
        _;
    }

    // Only Unviersity can add New college
    function addNewCollege (
        string memory _collegeName,
        address _collAddress,
        uint _collegeRegNo
    ) public onlyAdmin {
        collegeDetails[_collAddress].collegeName = _collegeName;
        collegeDetails[_collAddress].collegeAddress = _collAddress;
        collegeDetails[_collAddress].collegeRegNo = _collegeRegNo;
        collegeDetails[_collAddress].toAddStudents = false;  // Intially not permision to add Student for this college.
        collegeDetails[_collAddress].noOfStudents = 0;  // Initially No. of Student asigned as 0 to college
    }

    // Only college can add new student
    function addNewStudentToCollege(
        string memory _studentName,
        uint256 _studentPhoneNo,
        string memory _courseEnrolled
    ) public onlyCollege {
        require(collegeDetails[msg.sender].toAddStudents, "You are not allowed to add Student.");
        studentDetails[_studentName].collAddress = msg.sender;
        studentDetails[_studentName].studentName = _studentName;
        studentDetails[_studentName].studentPhoneNo = _studentPhoneNo;
        studentDetails[_studentName].courseEnrolled = _courseEnrolled;
        // Add number of student to the concern college
        collegeDetails[msg.sender].noOfStudents++;
    }

    // Only University Admin can block the college to add student
    function blockCollegeToAddNewStudents(address _collegeAddress) public onlyAdmin {
        collegeDetails[_collegeAddress].toAddStudents = false;
    }

    // Only University Admin can allow the college to add student
    function unblockCollegeToAddNewStudents(address _collegeAddress) public onlyAdmin {
        collegeDetails[_collegeAddress].toAddStudents = true;
    }

    // Only college can change the course of the student
    function changeStudentCourse(
        string memory _studentName, 
        string memory _courseName
        ) public onlyCollege {
            require(studentDetails[_studentName].collAddress == msg.sender, "You are not allowed you to change the course.");
            studentDetails[_studentName].courseEnrolled = _courseName;
    }

    // Only University can get the number of student of any college by its address
    function getNoOfStudentForCollege(address _collegeAddress) public onlyAdmin view returns(uint) {
        return collegeDetails[_collegeAddress].noOfStudents;
    }

    // Anyone can view the details of student by his/her name
    function viewStudentDetails(string memory _studentName) public view returns(
        address,
        string memory,
        uint256,
        string memory
    ){
        return (
            studentDetails[_studentName].collAddress,
            studentDetails[_studentName].studentName,
            studentDetails[_studentName].studentPhoneNo,
            studentDetails[_studentName].courseEnrolled
        );
    }


    // Anyone can view colledge details
    function viewCollegeDetails(address _collegeAddress) public view returns(
        string memory,
        address,
        uint,
        bool,
        uint
    ) {
        return (
            collegeDetails[_collegeAddress].collegeName,
            collegeDetails[_collegeAddress].collegeAddress,
            collegeDetails[_collegeAddress].collegeRegNo,
            collegeDetails[_collegeAddress].toAddStudents,
            collegeDetails[_collegeAddress].noOfStudents
        );
    }

}