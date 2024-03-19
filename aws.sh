#!/usr/bin/env bash
/usr/bin/aws configure import --csv "file:///opt/aws/credentials.csv"
/usr/bin/aws configure set region us-west-2 --profile Xing
mkdir -p ~/desiroot/
/usr/bin/mount-s3 --cache ~/.desiroot_cache/ desiproto ~/desiroot/
