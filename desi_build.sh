#!/usr/bin/env bash

mamba install --yes \
    numpy scipy astropy \
    pyyaml requests ipython \
    h5py scikit-learn matplotlib \
    numba sqlalchemy pytz \
    sphinx seaborn \
    fitsio

pip install healpy speclite

mkdir -p $DESI_HUB
pushd $DESI_HUB
for package in desiutil specter specsim desitarget desispec desisim desimodel redrock redrock-templates desisurvey surveysim; do
  git clone https://github.com/desihub/$package.git --depth 1
done
popd
