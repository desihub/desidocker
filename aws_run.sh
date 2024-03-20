#!/usr/bin/env bash

/usr/bin/aws configure import --csv "file:///aws_credentials.csv"
/usr/bin/mount-s3 \
    --cache $DESI_ROOT_CACHE \
    --region us-west-2 \
    --read-only \
    desiproto $DESI_ROOT
