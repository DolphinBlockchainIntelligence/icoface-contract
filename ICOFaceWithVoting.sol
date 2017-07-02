pragma solidity ^0.4.10;

contract Voting {
    uint birth_block;
    address parent;
    mapping (address => bool) has_voted;
    uint votes_for = 0;
    uint votes_against = 0;

    
    function Voting() {
        birth_block = block.number;
        parent = msg.sender;
    }
    
    function birthBlock() constant returns (uint block) {
        return birth_block;
    }
    
    function votesFor() constant returns (uint votes) {
        return votes_for;
    }
    
    function votesAgainst() constant returns (uint votes) {
        return votes_against;
    }
    
    function voteFor(address voter) {
        if (msg.sender != parent || has_voted[voter] == true) {
            throw;
        }
        has_voted[voter] = true;
        votes_for += 1;
    }
    
    function voteAgainst(address voter) {
        if (msg.sender != parent || has_voted[voter] == true) {
            throw;
        }
        has_voted[voter] = true;
        votes_against += 1;
    }
    
    function cleanUp() {
        if (msg.sender != parent) {
            throw;
        }
        selfdestruct(parent);
    }
    
}

contract ICOFace {
    
    mapping (address => bool) banned;
    
    struct Persona {
        string name;
        string role;
        string projectName;
        string personLink;
        string photoLink;
        string pageLink;
    }
    
    struct PersonaQueue {
        Persona[] data;
        uint front;
        uint back;
    }
    
    Voting current_voting;
    bool voting_on = false;
    
    Persona[] approved;
    PersonaQueue pending;
    
    function numberOfApproved() constant returns (uint length) {
        return approved.length;
    }
    
    function numberOfPending() constant returns (uint length) {
        return pending.back - pending.front;
    }
    
    function addToPending(string name, string role, string projectName, string personLink, string photoLink, string pageLink) {
        pending.data.push(Persona(name, role, projectName, personLink, photoLink, pageLink));
        pending.back += 1;
    }
    
    function startVoting() {
        current_voting = new Voting();
        voting_on = true;
    }
    
    function vote(bool is_for) {
        if (voting_on == false || current_voting.birthBlock() + 240 <= block.number) {
            throw;
        }
        current_voting.voteFor(msg.sender);
    }
    
    function  resolveVoting() internal {
        if (current_voting.birthBlock() + 240 > block.number) {
            throw;
        }
        
        if (current_voting.votesFor() > current_voting.votesAgainst()) {
            approved.push(pending.data[pending.front]);
            pending.front += 1;
        } else {
            pending.front += 1;
        }
        current_voting.cleanUp();
        voting_on = false;
    }
    
    function getPending(uint index) constant returns (string name, string role, string projectName, string personLink, string photoLink, string pageLink) {
        return (pending.data[pending.front + index].name,
                pending.data[pending.front + index].role,
                pending.data[pending.front + index].projectName,
                pending.data[pending.front + index].personLink,
                pending.data[pending.front + index].photoLink,
                pending.data[pending.front + index].pageLink);
    }
    
    function getApproved(uint index) constant returns (string name, string role, string projectName, string personLink, string photoLink, string pageLink) {
        return (approved[index].name,
                approved[index].role,
                approved[index].projectName,
                approved[index].personLink,
                approved[index].photoLink,
                approved[index].pageLink);
    }
    
    function () {
        throw;
    }
    
}