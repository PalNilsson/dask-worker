# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
#
# Authors:
# - Paul Nilsson, paul.nilsson@cern.ch, 2023

FROM continuumio/miniconda3:22.11.1

# Tag for selecting the dask version
ARG DASK_VERSION

# Tag for selecting a package to be pip installed (e.g. dask-ml[complete])
ARG PACKAGE

MAINTAINER Paul Nilsson
USER root

RUN conda install --yes \
    -c conda-forge \
    python==3.9 \
    python-blosc \
    cytoolz \
    dask==$DASK_VERSION \
    lz4 \
    nomkl \
    numpy==1.24.3 \
    pandas==2.0.1 \
    tini==0.19.0 \
    && conda clean -tipsy \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs

# install optional package
RUN if [[ -z "$PACKAGE" ]] ; then echo No additional package ; else python3 -m pip install --no-cache-dir $PACKAGE ; fi

COPY prepare.sh /usr/bin/prepare.sh
RUN mkdir /opt/app

# The following env vars must be used to connect the worker to the dask scheduler and use the proper NFS mount point
ARG DASK_SCHEDULER_IP
ARG DASK_SHARED_FILESYSTEM_PATH

# Activate the environment, and make sure it's activated:
RUN conda init bash
COPY environment.yml /opt/app/.
RUN conda env create -f /opt/app/environment.yml
RUN activate myenv

# Execute the prepare script which starts the dask worker
ENTRYPOINT ["tini", "-g", "--", "/usr/bin/prepare.sh"]
