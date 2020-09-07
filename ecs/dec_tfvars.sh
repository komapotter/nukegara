#!/bin/bash

echo "${PWD}"
aws kms decrypt --ciphertext-blob fileb://terraform.tfvars.encrypted \
    --output text \
    --query Plaintext \
  | base64 --decode > terraform.tfvars.decrypted
