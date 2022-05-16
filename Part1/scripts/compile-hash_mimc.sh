#!/bin/bash

cd circuits

mkdir Hash_mimc

if [ -f ./powersOfTau28_hez_final_16.ptau ]; then
    echo "powersOfTau28_hez_final_16.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_16.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_16.ptau
fi

echo "Compiling Hash_mimc.circom..."

# compile Hash_mimc

circom Hash_mimc.circom --r1cs --wasm --sym -o .
snarkjs r1cs info Hash_mimc.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup Hash_mimc.r1cs powersOfTau28_hez_final_16.ptau Hash_mimc_0000.zkey
snarkjs zkey contribute Hash_mimc_0000.zkey Hash_mimc_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey Hash_mimc_final.zkey Hash_mimc_verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier Hash_mimc_final.zkey ../contracts/Hash_mimc_verifier.sol

cd ../..
