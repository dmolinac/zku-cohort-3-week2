pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";

template Hash() {
    signal input in;
    signal output out;

    component poseidon = Poseidon(1);

    poseidon.inputs[0] <== in;

    out <== poseidon.out;
}

component main = Hash();