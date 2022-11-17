// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract PropertyTransferApp {
    
    address public contractOwner;

    constructor () {
        contractOwner = msg.sender;
    }

    modifier onlyOwner(){
        require (msg.sender == contractOwner);
        _;
    }

    struct Property {
        uint256 id;
        string name;
        string owner;
        uint256 value;
        uint256 area;
    }

    mapping (uint256 => Property) public properties;

    function addProperty(
        uint256 _propertyId,
        string memory _name,
        string memory _owner,
        uint256 _value,
        uint256 _area
    ) public onlyOwner {
        properties[_propertyId].name = _name;
        properties[_propertyId].owner = _owner;
        properties[_propertyId].value = _value;
        properties[_propertyId].area = _area;
    }

    function queryPropertyById(uint256 _propertyId) public view returns (
        string memory name,
        string memory owner,
        uint256 value,
        uint256 area
    )
    {
        return(
            properties[_propertyId].name,
            properties[_propertyId].owner,
            properties[_propertyId].value,
            properties[_propertyId].area
        );
    }

    function transferPropertyOwnership(uint256 _propertyId, string memory _newOwner) public onlyOwner {
        properties[_propertyId].owner = _newOwner;
    }
}