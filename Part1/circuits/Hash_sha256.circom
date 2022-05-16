pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/sha256/sha256.circom";

template Hash() {
    signal input in;
    signal output out;

    component sha256 = Sha256(2);

    sha256.in[0] <== 0;
    sha256.in[2] <== 1;
    out <== sha256.out;
}

//component main = Hash();
component main = Sha256(1);