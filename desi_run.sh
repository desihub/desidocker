#!/usr/bin/env bash

# Add DESI Python libraries to PATH and PYTHONPATH
# so they can be easily imported

pushd $DESI_HUB
for package in desiutil specter desitarget desispec desisim desimodel redrock desisurvey surveysim; do
  export PATH=$DESI_HUB/$package/bin:$PATH
  export PYTHONPATH=$DESI_HUB/$package/py:$PYTHONPATH
done
export PYTHONPATH=$DESI_HUB/specsim:$PYTHONPATH
popd
