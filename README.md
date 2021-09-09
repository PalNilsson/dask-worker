# dask-worker
Docker image scripts for a Dask worker.

This image can be used to start a Dask worker. It is based on the continuumio/miniconda3:4.8.2 image and installs Dask version 2021.7.2, Python 3.8,
numpy 1.21.1, pandas 1.3.0 as well as a few other tools.

## Build instructions

1. docker build -t dask-worker:latest .
2. Identify the < build tag > at the bottom of the stdout from the previous step
3. docker tag < build tag > < docker username >/dask-worker:latest
4. docker push < docker username >/dask-worker:latest

