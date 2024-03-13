# Ubuntu 22.04 (jammy)
# https://hub.docker.com/_/ubuntu/tags?page=1&name=jammy
ARG ROOT_CONTAINER=ubuntu:22.04
ARG DEFAULT_USER=user

FROM $ROOT_CONTAINER

# --- Install basic dependencies ---

USER root
WORKDIR /

RUN apt-get update --yes
RUN apt-get upgrade --yes
RUN apt-get install --yes --no-install-recommends \
    unzip \
    ca-certificates \
    sudo \
    wget
RUN apt-get clean

# --- Configure environment ---

USER $DEFAULT_USER
WORKDIR /

# Shell
ENV SHELL=/bin/bash

# Directories
ENV HOME=/home/$DEFAULT_USER
ENV TEMP=/tmp
ENV BIN_FOLDER=/tmp/bin
ENV CONDA_DIR=/opt/conda
ENV AWS_DIR=/opt/aws
ENV PATH="${CONDA_DIR}/bin:${AWS_DIR}/bin:${PATH}"

# Architecture
ENV ARCH="$(uname -i)"

# --- Install AWS ---

USER root
WORKDIR "${TEMP}"

# Install aws-cli
RUN wget "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -i).zip" -O "./awscli.zip"
RUN unzip "./awscli.zip"
RUN "${SHELL}" "./aws/install" \
    -i "${AWS_DIR}/aws-cli" \
    -b "${AWS_DIR}/bin"

# Install mountpoint
RUN wget "https://s3.amazonaws.com/mountpoint-s3-release/latest/$(uname -i)/mount-s3.deb" -O "./mount-s3.deb"
RUN apt-get install --yes --no-install-recommends "./mount-s3.deb"

# --- Install Jupyter ---

USER root
WORKDIR "${TEMP}"

# Download and install Micromamba, and initialize the Conda prefix.
# https://mamba.readthedocs.io/en/latest/installation/micromamba-installation.html
# https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html
RUN wget "https://micro.mamba.pm/install.sh" -O - | "${SHELL}"

# Install Python, Mamba, and jupyter_core via Micromamba
RUN "${BIN_FOLDER}/micromamba" install \
    --root-prefix="${CONDA_DIR}" \
    --prefix="${CONDA_DIR}" \
    --yes \
    'python' \
    'mamba' \
    'jupyter_core'
# Cleanup temporary files and remove Micromamba
RUN rm -rf "${BIN_FOLDER}/micromamba"
RUN mamba clean --all -f -y

# Install JupyterLab, Jupyter Notebook, Jupyter hub via Mamba
RUN mamba install --yes \
    'jupyterlab' \
    'notebook' \
    'jupyterhub' \
    'nbclassic'
RUN mamba clean --all -f -y

# --- Setup Jupyter ---

USER $DEFAULT_USER
WORKDIR "${TEMP}"

# Configure Jupyter
RUN jupyter server --generate-config
RUN jupyter lab clean

ENV JUPYTER_PORT=8888
EXPOSE $JUPYTER_PORT

# Finish

USER $DEFAULT_USER
WORKDIR "${HOME}"
