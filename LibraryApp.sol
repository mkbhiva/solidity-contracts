// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract LibraryApp {
    
    // Declare the variable for Owner
    address libraryOwner;

    // Set Library Owner
    constructor() {
        libraryOwner = msg.sender;
    }

    // Set Modifier to confirm its owner
    modifier onlyOwner() {
        require(libraryOwner == msg.sender);
        _;
    }

    // Set Structure variable for Books
    struct Book {
        uint256 id;
        string bookName;
        string authorName;
        uint256 price;
        string assignTo;
    }

    // Map book to book details
    mapping (uint256 => Book) public Bookinfo;


    // Add book in the list to the Library handle by Library Owner only.
    function addBook(
        uint256 _bookId, 
        string memory _bookName, 
        string memory _authorName, 
        uint256 _price, 
        string memory _asignTo
        ) public onlyOwner {
            Bookinfo[_bookId].bookName = _bookName;
            Bookinfo[_bookId].authorName = _authorName;
            Bookinfo[_bookId].price = _price;
            Bookinfo[_bookId].assignTo = _asignTo;
    }


    // Get book by its id and return the Books details
    function getBookById(uint256 _bookId) public view returns (
        string memory bookName, 
        string memory authorName, 
        uint256 price, 
        string memory assignTo
        ){
            return (
                Bookinfo[_bookId].bookName,
                Bookinfo[_bookId].authorName,
                Bookinfo[_bookId].price,
                Bookinfo[_bookId].assignTo
            );

    }

    // Issue the Book by its ID to a person, only Library Owner can do this
    function issueBookTo(uint256 _bookId, string memory _newOwner) public onlyOwner {
        Bookinfo[_bookId].assignTo = _newOwner;
    }


}