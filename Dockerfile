FROM python:3-bullseye

ARG PLATFORM_IO_VERSION=6.1.1

# Update PIP
RUN pip install --upgrade pip

# Install PlatformIO, and it's newest available dependencies via pip.
RUN pip install -U PlatformIO==${PLATFORM_IO_VERSION}

# Delete entrypoint of parent containers (required by Azure Pipelines)
ENTRYPOINT []