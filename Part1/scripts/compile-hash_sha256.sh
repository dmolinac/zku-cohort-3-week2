#!/bin/bash

cd circuits

mkdir Hash_sha256

if [ -f ./powersOfTau28_hez_final_16.ptau ]; then
    echo "powersOfTau28_hez_final_16.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_16.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_16.ptau
fi

echo "Compiling Hash_sha256.circom..."

# compile Hash_sha256

circom Hash_sha256.circom --r1cs --wasm --sym -o .
snarkjs r1cs info Hash_sha256.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup Hash_sha256.r1cs powersOfTau28_hez_final_16.ptau Hash_sha256_0000.zkey
snarkjs zkey contribute Hash_sha256_0000.zkey Hash_sha256_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey Hash_sha256_final.zkey Hash_sha256_verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier Hash_sha256_final.zkey ../contracts/Hash_sha256_verifier.sol

cd ../..
