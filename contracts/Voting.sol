// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {
    address private _owner = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;

    uint256 private rand = 0;

    uint256 private startPeriod;
    uint256 private endPeriod;
    bool public rewarded;

    event Times(uint256);
    event VoteEvent(address, string);
    event SentReward(address, address, string);

    struct Candidate {
        string candidateName;
        uint32 count;
    }
    mapping(uint256 => address[]) public voterList;

    struct Voters {
        bool statusVotes;
        uint256 timeVotes;
    }

    mapping(address => Voters) internal dataVoters;

    Candidate[] public listCandidate;

    constructor(uint256 end) {
        startPeriod = block.timestamp;
        endPeriod = startPeriod + end;
        rewarded = false;
        dataVoters[msg.sender].statusVotes = true;
        emit Times(block.timestamp);
    }

    function addCandidate(string[] memory candidates) public onlyOwner returns(bool) {
        for (uint8 i = 0; i < candidates.length; i++) {
            listCandidate.push(
                Candidate({candidateName: candidates[i], count: 0})
            );
        }
        return true;
    }

    function vote(uint256 candidatesNumber) public {
        emit Times(block.timestamp);
        // require(block.timestamp < startPeriod,"vote period not started");
        require(block.timestamp < endPeriod, "vote period has been ended");
        require(
            dataVoters[msg.sender].statusVotes == false,
            "user has been voted"
        );
        require(
            candidatesNumber <= listCandidate.length,
            "candidate not found"
        );

        listCandidate[candidatesNumber].count += 1;
        dataVoters[msg.sender].statusVotes = true;
        dataVoters[msg.sender].timeVotes = block.timestamp;
        voterList[candidatesNumber].push(msg.sender);
        emit VoteEvent(msg.sender, "has been voted");
    }

    function winners() public view returns (uint256 winner) {
        require(block.timestamp > endPeriod, "Period not ended");
        uint256 total;
        for (uint256 i = 0; i < listCandidate.length; i++) {
            uint256 totalTemp = voterList[i].length;
            if (total < totalTemp) {
                total = totalTemp;
                winner = i;
            }
        }
        return winner;
    }

    function winnerName() public view returns (string memory winName) {
        winName = listCandidate[winners()].candidateName;
    }

    function getRandom(uint256 limit) internal view returns (uint256) {
        return
            uint256(
                keccak256(abi.encodePacked(block.timestamp, msg.sender, rand))
            ) % limit;
    }

    function sendReward() public {
        require(!rewarded, "has been rewarded");
        uint256 win = winners();
        uint256 limit = voterList[win].length;
        uint256 randoms = getRandom(limit);
        address payable winnerAddress = payable(voterList[win][randoms]);
        winnerAddress.transfer(1**17);
        rewarded = true;
        emit SentReward(msg.sender, winnerAddress, "Sukses Dikirim");
    }
}
