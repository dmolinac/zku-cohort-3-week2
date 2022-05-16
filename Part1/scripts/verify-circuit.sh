#!/bin/bash

cd circuits

# DMC: 3a.- Generate witness from input data (in.json). Output is witness.wtns
node circuit_js/generate_witness.js circuit_js/circuit.wasm in.json witness.wtns

# DMC: 3b.- Export/Display the witness to witness.json
snarkjs wtns export json witness.wtns witness.json

# DMC: 4.- Generate the prove. Outputs are proof.json and public.json
snarkjs groth16 prove circuit_final.zkey witness.wtns proof.json public.json

# DMC: 5.- Verify the proof
snarkjs groth16 verify verification_key.json public.json proof.json

cd ..
