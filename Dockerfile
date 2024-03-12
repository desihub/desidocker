# Ubuntu 22.04 (jammy)
# https://hub.docker.com/_/ubuntu/tags?page=1&name=jammy
ARG ROOT_CONTAINER=ubuntu:22.04

FROM $ROOT_CONTAINER

USER root

# Install all OS dependencies for the Server that starts
# but lacks all features (e.g., download as all possible file formats)
RUN apt-get update --yes
    # - `apt-get upgrade` is run to patch known vulnerabilities in system packages
    #   as the Ubuntu base image is rebuilt too seldom sometimes (less than once a month)
RUN apt-get upgrade --yes
RUN apt-get install --yes --no-install-recommends \
    unzip \
    ca-certificates \
    sudo \
    wget
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure environment
ENV CONDA_DIR=/opt/conda
ENV AWS_DIR=/opt/aws
ENV TEMP=/tmp
ENV HOME=/home
ENV SHELL=/bin/bash
ENV PATH="${CONDA_DIR}/bin:${AWS_DIR}/bin:${PATH}"
ENV BIN_FOLDER=/tmp/bin

WORKDIR "${TEMP}"

# --- Install AWS ---

RUN wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -O "./awscli.zip"
RUN unzip "./awscli.zip"
RUN "${SHELL}" "./aws/install" \
    -i "${AWS_DIR}/aws-cli" \
    -b "${AWS_DIR}/bin"

# --- Install Jupyter ---

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

# Configure Jupyter
RUN jupyter server --generate-config
RUN jupyter lab clean

ENV JUPYTER_PORT=8888
EXPOSE $JUPYTER_PORT


WORKDIR "${HOME}"
