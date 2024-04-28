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

# Set release to latest public release (edr), unless user-specified at runtime.
# The ,, forces lowercase.

if [ -z "$DESI_RELEASE" ]; then
    export DESI_RELEASE=edr
fi
DESI_RELEASE=${DESI_RELEASE,,}
echo "+ Set \$DESI_ROOT to the $DESI_RELEASE release."
export DESI_ROOT=$DESI_DATA/$DESI_RELEASE
export DESI_RAW=$DESI_DATA/raw_spectro_data
export DESI_TARGET=$DESI_DATA/target

ln -s $DESI_ROOT/spectro $DESI_SPECTRO_NERSC

# If $DESI_DATA is not already occupied (by a local mount), 
# then mount AWS S3 bucket to $DESI_DATA, with cache at $DESI_DATA_CACHE.

if [ "$(ls -A $DESI_DATA)" ]; then
    echo "+ Mounted local DESI data directory."
else
    echo "+ Mounting remote DESI data directory..."
    mount-s3 \
        --cache $DESI_DATA_CACHE \
        --region us-west-2 \
        --read-only \
        --no-sign-request \
        desidata $DESI_DATA
fi

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

echo "+ Starting Jupyter..."
echo ""
/usr/local/bin/start.sh start-notebook.py

# Unmount when done

umount $DESI_DATA
