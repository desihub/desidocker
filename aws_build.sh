#!/usr/bin/env bash

# Configure AWS and set-up Mountpoint directories

aws configure set region us-west-2 --profile default
mkdir -p $DESI_ROOT $DESI_ROOT_CACHE
