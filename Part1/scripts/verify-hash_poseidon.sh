#!/bin/bash

cd circuits

# DMC: 3a.- Generate witness from input data (in.json). Output is witness.wtns
node Hash_poseidon_js/generate_witness.js Hash_poseidon_js/Hash_poseidon.wasm in_poseidon.json Hash_poseidon_witness.wtns

# DMC: 3b.- Export/Display the witness to witness.json
snarkjs wtns export json Hash_poseidon_witness.wtns Hash_poseidon_witness.json

# DMC: 4.- Generate the prove. Outputs are proof.json and public.json
snarkjs groth16 prove Hash_poseidon_final.zkey Hash_poseidon_witness.wtns Hash_poseidon_proof.json Hash_poseidon_public.json

# DMC: 5.- Verify the proof
ts=$(gdate +%s%N) ;
snarkjs groth16 verify Hash_poseidon_verification_key.json Hash_poseidon_public.json Hash_poseidon_proof.json
tt=$((($(gdate +%s%N) - $ts)/1000000));
echo "Time taken: $tt milliseconds"
