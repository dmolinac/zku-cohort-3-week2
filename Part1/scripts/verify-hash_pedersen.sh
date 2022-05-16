#!/bin/bash

cd circuits

# DMC: 3a.- Generate witness from input data (in.json). Output is witness.wtns
node Hash_pedersen_js/generate_witness.js Hash_pedersen_js/Hash_pedersen.wasm in_pedersen.json Hash_pedersen_witness.wtns

# DMC: 3b.- Export/Display the witness to witness.json
snarkjs wtns export json Hash_pedersen_witness.wtns Hash_pedersen_witness.json

# DMC: 4.- Generate the prove. Outputs are proof.json and public.json
snarkjs groth16 prove Hash_pedersen_final.zkey Hash_pedersen_witness.wtns Hash_pedersen_proof.json Hash_pedersen_public.json

# DMC: 5.- Verify the proof
ts=$(gdate +%s%N) ;
snarkjs groth16 verify Hash_pedersen_verification_key.json Hash_pedersen_public.json Hash_pedersen_proof.json
tt=$((($(gdate +%s%N) - $ts)/1000000));
echo "Time taken: $tt milliseconds"
