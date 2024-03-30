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
ENV DESI_HUB=$HOME/desihub
ENV DESI_ROOT=$HOME/desiroot
ENV DESI_ROOT_CACHE=$HOME/.desiroot_cache
ENV USR_BIN=/usr/bin
ENV LOCAL_BIN=/usr/local/bin
ENV MOUNT=/mnt/local_volume

# Install AWS 
# ===========
# $(uname -i) returns the device hardware platform architecture,
# e.g. x86_64, amd64, required for downloading the right executables

USER root
WORKDIR /tmp

# Ensure all dependencies can be installed

RUN apt-get update --yes \
    && apt-get upgrade --yes \
    && apt-get clean

# Install mountpoint
RUN wget "https://s3.amazonaws.com/mountpoint-s3-release/latest/$(uname -i)/mount-s3.deb" -O ./mount-s3.deb \
    && apt-get install --yes --no-install-recommends ./mount-s3.deb \
    && apt-get clean \
    && rm ./mount-s3.deb

# *_build.sh scripts execute during `docker image build`
COPY ./build.sh $LOCAL_BIN
RUN chmod +x $LOCAL_BIN/build.sh \
    $LOCAL_BIN/build.sh

# *_run.sh scripts execute during `docker run` via main.sh
COPY ./run.sh $LOCAL_BIN
RUN chmod +x $LOCAL_BIN/run.sh
ENTRYPOINT $LOCAL_BIN/run.sh

# Fix permissions for home directory 
RUN fix-permissions $HOME

# Return to user privileges
USER ${NB_UID}
WORKDIR $HOME

