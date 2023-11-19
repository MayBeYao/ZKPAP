// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IPFS {
    mapping(bytes32 => string) private data;

    function store(string memory _data) public returns (bytes32) {
        bytes32 hash = keccak256(abi.encodePacked(block.timestamp, _data));
        data[hash] = _data;
        return hash;
    }

    function retrieve(bytes32 _hash) public view returns (string memory) {
        return data[_hash];
    }
}
