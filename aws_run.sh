#!/usr/bin/env bash

# Import AWS credentials, fix them, authenticate with fixed credentials, then run Mountpoint

python3 $LOCAL_BIN/fix_credentials.py "/tmp/aws_credentials.csv" "/tmp/aws_credentials_fixed.csv"
aws configure import --csv "file:///tmp/aws_credentials_fixed.csv"
mount-s3 \
    --cache $DESI_ROOT_CACHE \
    --region us-west-2 \
    --read-only \
    desiproto $DESI_ROOT
