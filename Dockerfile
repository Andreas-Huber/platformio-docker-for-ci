FROM python:3.8-buster

# Install PlatformIO, and it's newest available dependencies via pip.
RUN pip install -U PlatformIO==5.0.1

# Delete entrypoint of parent containers (required by Azure Pipelines)
ENTRYPOINT []