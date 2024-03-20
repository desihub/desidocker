#!/usr/bin/env bash

/usr/bin/aws configure import --csv "file:///opt/aws/credentials.csv"
/usr/bin/mount-s3 \
    --cache $DESI_ROOT_CACHE \
    --region us-west-2 \
    desiproto $DESI_ROOT

exit 0
