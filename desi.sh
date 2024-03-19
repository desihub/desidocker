#!/usr/bin/env bash
conda create --name desi --yes python=3.10 numpy scipy astropy pyyaml requests ipython h5py scikit-learn matplotlib numba sqlalchemy pytz sphinx seaborn
conda activate desi
pip install healpy speclite
conda install -c conda-forge fitsio

export DESI_PRODUCT_ROOT=$HOME/desi/code
mkdir -p $DESI_PRODUCT_ROOT
cd $DESI_PRODUCT_ROOT
for package in desiutil specter specsim desitarget desispec desisim desimodel redrock redrock-templates desisurvey surveysim; do
  git clone https://github.com/desihub/$package --depth 1
done

cd $DESI_PRODUCT_ROOT
for package in desiutil specter desitarget desispec desisim desimodel redrock desisurvey surveysim; do
  export PATH=$DESI_PRODUCT_ROOT/$package/bin:$PATH
  export PYTHONPATH=$DESI_PRODUCT_ROOT/$package/py:$PYTHONPATH
done
export PYTHONPATH=$DESI_PRODUCT_ROOT/specsim:$PYTHONPATH
