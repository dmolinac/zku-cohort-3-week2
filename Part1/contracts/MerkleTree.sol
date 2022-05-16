//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { PoseidonT3 } from "./Poseidon.sol"; //an existing library to perform Poseidon hash on solidity
import "./verifier.sol"; //inherits with the MerkleTreeInclusionProof verifier contract

contract MerkleTree is Verifier {
    uint256[] public hashes; // the Merkle tree in flattened array form
    uint256 public index = 0; // the current index of the first unfilled leaf
    uint256 public root; // the current Merkle root

    constructor() {
        // [assignment] initialize a Merkle tree of 8 with blank leaves
        hashes = new uint256[](15);
        for (uint8 i = 0; i < 15; i++) {
            hashes[i] = 0;
        }
    }

    function insertLeaf(uint256 hashedLeaf) public returns (uint256) {
        // [assignment] insert a hashed leaf into the Merkle tree
        hashes[index] = hashedLeaf;
        index ++;

        // Rebuild Merkle tree
        uint i = 0;
        
        for(uint j = 0; j < (hashes.length-8)*2; j+=2) {
            hashes[i+8] = PoseidonT3.poseidon([hashes[j],hashes[j+1]]);
            i++;
        }

        root = hashes[hashes.length-1];
        return hashes[hashes.length-1];
    }

    function verify(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[1] memory input
        ) public view returns (bool) {

        // [assignment] verify an inclusion proof and check that the proof root matches current root
        verifyProof(a,b,c,input);

        if(input[0] == root) {
            return true;
        } else {
            return false;
        }
    }
}
