# Build from container provided by Jupyter
# ========================================
# Options for JUPYTER_BASE include
# - minimal-notebook (default)
# - scipy-notebook
# - pytorch-notebook
# - julia-notebook
# and others, listed at https://github.com/jupyter/docker-stacks
# All Jupyter containers contain a rootless user $NB_UID

ARG STACK_REGISTRY=quay.io
ARG STACK_OWNER=jupyter
ARG STACK_BASE=minimal-notebook
ARG STACK_VERSION=latest
FROM $STACK_REGISTRY/$STACK_OWNER/$STACK_BASE:$STACK_VERSION

# Slight customization to bash
# ============================
# This fails commands even if errors occur before a pipe
# https://docs.docker.com/develop/develop-images/instructions/#using-pipes

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Directories
ENV HOME=/home/$NB_UID
ENV TEMP=/tmp
ENV AWS_DIR=/opt/aws
ENV PATH="$${AWS_DIR}/bin:${PATH}"

USER root

RUN apt-get update --yes \
    && apt-get upgrade --yes \
    && apt-get clean

# Install AWS 
# ===========
# $(uname -i) returns the device hardware platform architecture,
# e.g. x86_64, amd64, required for downloading the right executables

USER root
WORKDIR "${TEMP}"

# Install aws-cli
RUN wget "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -i).zip" -O ./awscli.zip \
    && unzip ./awscli.zip \
    && chmod +x ./aws/install \
    && ./aws/install \
    -i "${AWS_DIR}/aws-cli" \
    -b "${AWS_DIR}/bin"

# Install mountpoint
RUN wget "https://s3.amazonaws.com/mountpoint-s3-release/latest/$(uname -i)/mount-s3.deb" -O ./mount-s3.deb \
    && apt-get install --yes --no-install-recommends "./mount-s3.deb"


USER ${NB_UID}

WORKDIR "${HOME}"
