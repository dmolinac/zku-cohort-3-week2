#!/bin/bash

cd circuits

# DMC: 3a.- Generate witness from input data (in.json). Output is witness.wtns
node Hash_mimc_js/generate_witness.js Hash_mimc_js/Hash_mimc.wasm in_mimc.json Hash_mimc_witness.wtns

# DMC: 3b.- Export/Display the witness to witness.json
snarkjs wtns export json Hash_mimc_witness.wtns Hash_mimc_witness.json

# DMC: 4.- Generate the prove. Outputs are proof.json and public.json
snarkjs groth16 prove Hash_mimc_final.zkey Hash_mimc_witness.wtns Hash_mimc_proof.json Hash_mimc_public.json

# DMC: 5.- Verify the proof
ts=$(gdate +%s%N) ;
snarkjs groth16 verify Hash_mimc_verification_key.json Hash_mimc_public.json Hash_mimc_proof.json
tt=$((($(gdate +%s%N) - $ts)/1000000));
echo "Time taken: $tt milliseconds"
