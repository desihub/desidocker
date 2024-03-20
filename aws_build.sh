#!/usr/bin/env bash

/usr/bin/aws configure set region us-west-2 --profile default
mkdir -p $DESI_ROOT $DESI_ROOT_CACHE

exit 0
