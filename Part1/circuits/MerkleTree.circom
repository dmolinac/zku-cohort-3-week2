pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/mux1.circom";

template CheckRoot(n) { // compute the root of a MerkleTree of n Levels 
    signal input leaves[2**n];
    signal output root;

    var numberofleaves = 2**n;
    var numofhashes = 2*2**n-1;
    var merkletree[numofhashes];

    //log(numofhashes);    //15
    //log(numberofleaves); //8

    component poseidon[numofhashes];

    // Index of the merkle tree
    var i;

    // We build the merkle tree in two steps:

    // 1.- Hashes of leaves (input)
    for (i=0; i<numberofleaves; i++) {
        merkletree[i] = leaves[i];
    }

    //for(var j=0; j < numberofleaves; j++) {
    //    log(merkletree[j]);
    //}
    //log(i);

    // 2.- Rest of hashes
    for(var j=0; j < (numofhashes-numberofleaves)*2; j+=2) {
        poseidon[i] = Poseidon(2);
        //log(merkletree[j]);
        //log(merkletree[j+1]);
        poseidon[i].inputs[0] <== merkletree[j];
        poseidon[i].inputs[1] <== merkletree[j+1];
        merkletree[i] = poseidon[i].out;
        //log(merkletree[i]);
        i++;
        //log(j); log(i);
        } 

    for(var j=0; j < numofhashes; j++) {
        log(merkletree[j]);
    }
    root <== merkletree[numofhashes-1];
}

template MerkleTreeInclusionProof(n) {
    signal input leaf;
    signal input path_elements[n];
    signal input path_index[n]; // path index are 0's and 1's indicating whether the current element is on the left or right
    signal output root; // note that this is an OUTPUT signal

    component poseidon[n];
    component multiMux1[n];

    var hash = leaf;

    for(var i=0; i < n; i++) {

        // path_index to be binary
        path_index[i] * (path_index[i]-1) === 0;

        poseidon[i] = Poseidon(2);
        multiMux1[i] = MultiMux1(2);

        multiMux1[i].c[0][0] <== hash;
        multiMux1[i].c[0][1] <== path_elements[i];

        multiMux1[i].c[1][0] <== path_elements[i];
        multiMux1[i].c[1][1] <== hash;

        multiMux1[i].s <== path_index[i];
        poseidon[i].inputs[0] <== multiMux1[i].out[0];
        poseidon[i].inputs[1] <== multiMux1[i].out[1];

        hash = poseidon[i].out;
        log(hash);
    }

    root <== hash;
}