#!/usr/bin/env bash

# Create home directory 

mkdir -p $HOME
echo "This is the home directory of this Docker container. 
Files inside \`synced\` (\`\$SYNCED\`) are synced to the directory in which you ran this container.
Files elsewhere (e.g. inside \`\$SCRATCH\`) are saved to a volume associated with this container, which you can access with \`docker volume\`.

DESI data releases are mounted at \`desiroot\` (\`\$DESI_ROOT\`). 
Example code for processing the data can be found at \`tutorials\`.
" > $HOME/README.md

# Create directories for mounting to AWS S3 Mountpoint

mkdir -p $DESI_ROOT $DESI_ROOT_CACHE

# Create directory for mounting to files outside Docker,
# and symlink it to the home directiory

mkdir -p $MOUNT
ln -s $MOUNT $SYNCED

# Install DESI Python dependencies with Mamba and pip
# (https://desi.lbl.gov/trac/wiki/Pipeline/GettingStarted/Laptop)
# (installing big libraries one-by-one to avoid memory issues)

for package in numpy scipy astropy pyyaml requests ipython h5py scikit-learn matplotlib numba sqlalchemy pytz sphinx seaborn; do
    mamba install -c conda-forge --yes $package
done
pip install healpy speclite
mamba install -c conda-forge --yes fitsio

# Install DESI Python libraries
# (https://github.com/desihub)

mkdir -p $DESI_HUB
for package in desiutil specter specsim desitarget desispec desisim desimodel redrock redrock-templates desisurvey surveysim; do
  git clone --depth 1 \
      https://github.com/desihub/$package.git \
      $DESI_HUB/$package
done

# Clone tutorials

git clone --depth 1 \
    https://github.com/desihub/tutorials.git \
    $HOME/tutorials
