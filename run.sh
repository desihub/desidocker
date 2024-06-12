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

# Set environment variables as per
# https://desidatamodel.readthedocs.io/en/latest/
echo "+ Set \$DESI_ROOT to the $DESI_RELEASE release."
export DESI_ROOT=$DESI_DATA/$DESI_RELEASE
export DESI_SPECTRO_DATA=$DESI_DATA/raw_spectro_data
export DESI_SPECTRO_REDUX=$DESI_ROOT/spectro/redux
export DESI_SPECTRO_CALIB=$DESI_ROOT/spectro/desi_spectro_calib
export DESI_TARGET=$DESI_DATA/target

# Symlink to NERSC-like directories
ln -s $DESI_ROOT/spectro $DESI_NERSC/spectro
ln -s $DESI_ROOT/survey $DESI_NERSC/survey
ln -s $DESI_ROOT/vac $DESI_NERSC/vac
ln -s $DESI_TARGET $DESI_NERSC/target

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

if [ -z "$PUBLIC_IP" ]; then
	exec /usr/local/bin/start-notebook.py 
else
	exec /usr/local/bin/start-notebook.py 2>&1 | (trap '' INT; exec sed -e "s/\/\/\S*:/\/\/$PUBLIC_IP:/")
fi


# Unmount when done

umount $DESI_DATA
