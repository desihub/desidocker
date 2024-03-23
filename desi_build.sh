#!/usr/bin/env bash

# Install DESI Python libraries from github.com/desihub

# Install big libraries one-by-one to avoid memory issues
for package in numpy scipy astropy pyyaml requests ipython h5py scikit-learn matplotlib numba sqlalchemy pytz sphinx seaborn; do
    mamba install --yes $package
done

pip install healpy speclite

mkdir -p $DESI_HUB
pushd $DESI_HUB
for package in desiutil specter specsim desitarget desispec desisim desimodel redrock redrock-templates desisurvey surveysim; do
  git clone https://github.com/desihub/$package.git --depth 1
done
popd
