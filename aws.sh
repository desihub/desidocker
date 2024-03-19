#!/usr/bin/env bash
/usr/bin/aws configure import --csv "file:///opt/aws/credentials.csv"
mkdir -p ~/desiroot && /usr/bin/mount-s3 desiproto ~/desiroot/
