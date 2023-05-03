# dask-worker
Docker image scripts for a Dask worker.

This image can be used to start a Dask worker. It is based on the condaforge/mambaforge:latest image and installs Dask[complete], Python 3.9,
numpy, pandas as well as a few other tools.

## Build instructions

1. docker build -t dask-worker:latest . --build-arg DASK_VERSION=2023.3.2 --build-arg PACKAGE=dask-ml[complete]
2. Identify the < build tag > at the bottom of the stdout from the previous step
3. docker tag < build tag > < docker username >/dask-worker:latest
4. docker push < docker username >/dask-worker:latest

