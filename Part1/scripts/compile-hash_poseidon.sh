#!/bin/bash

cd circuits

mkdir Hash_poseidon

if [ -f ./powersOfTau28_hez_final_16.ptau ]; then
    echo "powersOfTau28_hez_final_16.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_16.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_16.ptau
fi

echo "Compiling Hash_poseidon.circom..."

# compile Hash_poseidon

circom Hash_poseidon.circom --r1cs --wasm --sym -o .
snarkjs r1cs info Hash_poseidon.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup Hash_poseidon.r1cs powersOfTau28_hez_final_16.ptau Hash_poseidon_0000.zkey
snarkjs zkey contribute Hash_poseidon_0000.zkey Hash_poseidon_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey Hash_poseidon_final.zkey Hash_poseidon_verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier Hash_poseidon_final.zkey ../contracts/Hash_poseidon_verifier.sol

cd ../..
