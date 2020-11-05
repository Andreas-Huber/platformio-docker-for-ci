FROM python:3.8-buster

ARG PLATFORM_IO_VERSION=5.0.2

# Install PlatformIO, and it's newest available dependencies via pip.
RUN pip install -U PlatformIO==${PLATFORM_IO_VERSION}

# Delete entrypoint of parent containers (required by Azure Pipelines)
ENTRYPOINT []