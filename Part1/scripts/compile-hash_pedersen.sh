#!/bin/bash

cd circuits

mkdir Hash_pedersen

if [ -f ./powersOfTau28_hez_final_16.ptau ]; then
    echo "powersOfTau28_hez_final_16.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_16.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_16.ptau
fi

echo "Compiling Hash_pedersen.circom..."

# compile Hash_pedersen

circom Hash_pedersen.circom --r1cs --wasm --sym -o .
snarkjs r1cs info Hash_pedersen.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup Hash_pedersen.r1cs powersOfTau28_hez_final_16.ptau Hash_pedersen_0000.zkey
snarkjs zkey contribute Hash_pedersen_0000.zkey Hash_pedersen_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey Hash_pedersen_final.zkey Hash_pedersen_verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier Hash_pedersen_final.zkey ../contracts/Hash_pedersen_verifier.sol

cd ../..
