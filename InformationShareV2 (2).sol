// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract InformationSharing {
    struct Participant {
        bool isRegistered;
        bool isPunished;
        bool hasVoted;
        uint256 voteCount;
        uint256 rewardPoints;
        
        
    }
    string ipfsHash;

    struct Vote {
        uint256 voteCount;
    }

    mapping(address => Participant) private participants;
    mapping(address => string) private submittedInformation;
    mapping(uint256 => Vote) private votes;
    mapping(address => bool) private hasVoted;

    address private contractOwner;
    uint256 private thresholdVotes;
    uint256 private rewardPerVote;
    uint256 private voteIdCounter;

    constructor() {
        contractOwner = msg.sender;
        thresholdVotes = 3; // 设置投票阈值
        rewardPerVote = 10; // 每票的奖励点数
        voteIdCounter = 1;
    }

    modifier onlyRegistered() {
        require(participants[msg.sender].isRegistered, "Participant is not registered");
        _;
    }

    modifier onlyContractOwner() {
        require(msg.sender == contractOwner, "Only contract owner can call this function");
        _;
    }


    function registerParticipant() external {
        require(!participants[msg.sender].isRegistered, "Participant is already registered");
        participants[msg.sender].isRegistered = true;
    }

    function submitInformation(string calldata information) external onlyRegistered {
        require(!participants[msg.sender].isPunished, "Participant is punished");// 存储和处理信息的逻辑
        submittedInformation[msg.sender] = information;
    }

    function vote(address participantAddress) external onlyRegistered {
        require(!participants[msg.sender].isPunished, "Participant is punished");
        require(!hasVoted[msg.sender], "Participant has already voted");

        votes[voteIdCounter].voteCount++;
        participants[msg.sender].rewardPoints += rewardPerVote;

        if (votes[voteIdCounter].voteCount >= thresholdVotes) {
           punishParticipants(participantAddress); // 达到阈值的投票逻辑，对所有投票者进行惩罚
        }

        hasVoted[msg.sender] = true;
    }

    function punishParticipants(address participantAddress) private {
        participants[participantAddress].isPunished = true;
    }
    
    function getParticipantInformation(address  participantAddress) external view returns (string memory) {
        return submittedInformation[participantAddress];
    }
     

    function setThresholdVotes(uint256 votes) external onlyContractOwner {
        thresholdVotes = votes;
    }

    function setRewardPerVote(uint256 reward) external onlyContractOwner {
        rewardPerVote = reward;
    }

    function createVote() external onlyContractOwner {
        voteIdCounter++;
    }


    function setIPFSHash(string memory _ipfsHash) public {
        ipfsHash = _ipfsHash;
    }

    function getIPFSData() public view returns (string memory) {
        return ipfsHash;
    }


}
