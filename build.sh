#!/usr/bin/env bash

# Create home directory 

mkdir -p $HOME

# Create directories for mounting to AWS S3 Mountpoint

mkdir -p $DESI_ROOT $DESI_ROOT_CACHE

# Create directory for mounting to files outside Docker,
# and symlink it to the home directiory

mkdir -p $MOUNT
ln -s $MOUNT $HOME/synced

# Install DESI Python dependencies with Mamba and pip
# (https://desi.lbl.gov/trac/wiki/Pipeline/GettingStarted/Laptop)
# (installing big libraries one-by-one to avoid memory issues)

for package in numpy scipy astropy pyyaml requests ipython h5py scikit-learn matplotlib numba sqlalchemy pytz sphinx seaborn; do
    mamba install --yes $package
done

pip install healpy speclite

# Install DESI Python libraries
# (https://github.com/desihub)

mkdir -p $DESI_HUB
pushd $DESI_HUB
for package in desiutil specter specsim desitarget desispec desisim desimodel redrock redrock-templates desisurvey surveysim; do
  git clone https://github.com/desihub/$package.git --depth 1
done
popd
