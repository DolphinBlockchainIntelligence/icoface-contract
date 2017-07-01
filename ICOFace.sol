pragma solidity ^0.4.10;

contract ICOFace {
    
    struct Persona {
        string name;
        string role;
        string projectName;
        string personLink;
        string photoLink;
        string pageLink;
    }
    
    Persona[] records;
    
    function numberOfRecords() constant returns (uint length) {
        return records.length;
    }
    
    function append(string name, string role, string projectName, string personLink, string photoLink, string pageLink) {
        records.push(Persona(name, role, projectName, personLink, photoLink, pageLink));
    }
    
    function get(uint index) constant returns (string name, string role, string projectName, string personLink, string photoLink, string pageLink) {
        return (records[index].name,
                records[index].role,
                records[index].projectName,
                records[index].personLink,
                records[index].photoLink,
                records[index].pageLink);
    }
}