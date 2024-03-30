#!/usr/bin/env bash

echo "
|----------------------------------------------------------------------- 
|                         E   N   E   R   G   Y                        | 
|   ---------------------------------------------------------------| S | 
|   |           .                                  *               | P | 
|   |      *               __                       +     .        | E | 
| D |     .         _----_///       *                              | C | 
|   |   +          /   \ ///                .        *             | T | 
| A |             /     Y-/\     .                                 | R | 
|   |     +       |========|            +           *              | O | 
| R |             |/ \ / \ |                      |                | S | 
|   |      _-_    |   X   X|         *          --+--              | C | 
| K |   ==/___\   |\ / \ / |      +               |       ^-^      | O | 
|   |___--|   |---------------_______________________-----\_/\-/---| P | 
|   |     |   |              _______----------            | |_O    | I | 
|   |--------------------------------------------------------------- C | 
|                 I   N   S   T   R   U   M   E   N   T                | 
-----------------------------------------------------------------------| 
"

# Mount AWS S3 bucket to $DESI_ROOT, with cache at $DESI_ROOT_CACHE.

mount-s3 \
    --cache $DESI_ROOT_CACHE \
    --region us-west-2 \
    --read-only \
    --no-sign-request \
    desiproto $DESI_ROOT

# Add DESI Python libraries to PATH and PYTHONPATH
# so they can be easily imported
# (https://desi.lbl.gov/trac/wiki/Pipeline/GettingStarted/Laptop)

for package in desiutil specter desitarget desispec desisim desimodel redrock desisurvey surveysim; do
  export PATH=$DESI_HUB/$package/bin:$PATH
  export PYTHONPATH=$DESI_HUB/$package/py:$PYTHONPATH
done
export PYTHONPATH=$DESI_HUB/specsim:$PYTHONPATH

# Start the Jupyter server
# (https://github.com/jupyter/docker-stacks/blob/main/images/base-notebook/Dockerfile)

$LOCAL_BIN/start.sh start-notebook.py

