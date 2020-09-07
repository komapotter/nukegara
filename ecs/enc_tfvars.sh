#!/bin/bash

echo "${PWD}"
aws kms encrypt --key-id alias/terraform-variables \
    --plaintext fileb://terraform.tfvars \
    --output text --query CiphertextBlob \
    --output text \
  | base64 --decode > terraform.tfvars.encrypted
