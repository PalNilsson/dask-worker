# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
#
# Authors:
# - Paul Nilsson, paul.nilsson@cern.ch, 2021

FROM continuumio/miniconda3:4.8.2

MAINTAINER Paul Nilsson
USER root

RUN conda install --yes \
    -c conda-forge \
    python==3.8 \
    python-blosc \
    cytoolz \
    dask==2021.7.2 \
    lz4 \
    nomkl \
    numpy==1.21.1 \
    pandas==1.3.0 \
    tini==0.18.0 \
    && conda clean -tipsy \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs

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
