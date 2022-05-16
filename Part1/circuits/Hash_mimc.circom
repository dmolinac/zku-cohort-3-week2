pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/mimc.circom";

template Hash() {
  signal output out;

  component hashComponent = MiMC7(8);
  hashComponent.x_in <== 1;
  hashComponent.k <== 0;
  
  out <== hashComponent.out;
}

component main = Hash();