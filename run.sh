#!/usr/bin/env bash

echo ""
echo "|----------------------------------------------------------------------- "
echo "|                         E   N   E   R   G   Y                        | "
echo "|   ---------------------------------------------------------------| S | "
echo "|   |           .                                  *               | P | "
echo "|   |      *               __                       +     .        | E | "
echo "| D |     .         _----_///       *                              | C | "
echo "|   |   +          /   \ ///                .        *             | T | "
echo "| A |             /     Y-/\     .                                 | R | "
echo "|   |     +       |========|            +           *              | O | "
echo "| R |             |/ \ / \ |                      |                | S | "
echo "|   |      _-_    |   X   X|         *          --+--              | C | "
echo "| K |   ==/___\   |\ / \ / |      +               |       ^-^      | O | "
echo "|   |___--|   |---------------_______________________-----\_/\-/---| P | "
echo "|   |     |   |              _______----------            | |_O    | I | "
echo "|   |--------------------------------------------------------------- C | "
echo "|                 I   N   S   T   R   U   M   E   N   T                | "
echo "-----------------------------------------------------------------------| "
echo ""

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

pushd $DESI_HUB
for package in desiutil specter desitarget desispec desisim desimodel redrock desisurvey surveysim; do
  export PATH=$DESI_HUB/$package/bin:$PATH
  export PYTHONPATH=$DESI_HUB/$package/py:$PYTHONPATH
done
export PYTHONPATH=$DESI_HUB/specsim:$PYTHONPATH
popd

# Start the Jupyter server
# (https://github.com/jupyter/docker-stacks/blob/main/images/base-notebook/Dockerfile)

$LOCAL_BIN/start.sh start-notebook.py

