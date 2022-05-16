#!/bin/bash

cd circuits

# DMC: 3a.- Generate witness from input data (in.json). Output is witness.wtns
node Hash_sha256_js/generate_witness.js Hash_sha256_js/Hash_sha256.wasm in_sha256.json Hash_sha256_witness.wtns

# DMC: 3b.- Export/Display the witness to witness.json
snarkjs wtns export json Hash_sha256_witness.wtns Hash_sha256_witness.json

# DMC: 4.- Generate the prove. Outputs are proof.json and public.json
snarkjs groth16 prove Hash_sha256_final.zkey Hash_sha256_witness.wtns Hash_sha256_proof.json Hash_sha256_public.json

# DMC: 5.- Verify the proof
ts=$(gdate +%s%N) ;
snarkjs groth16 verify Hash_sha256_verification_key.json Hash_sha256_public.json Hash_sha256_proof.json
tt=$((($(gdate +%s%N) - $ts)/1000000));
echo "Time taken: $tt milliseconds"
