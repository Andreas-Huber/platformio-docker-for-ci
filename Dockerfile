FROM python:3.8-buster

# Install PlatformIO, and it's newest available dependencies via pip.
RUN pip install -U PlatformIO==4.3.4

# Delete entrypoint of parent containers (required by Azure Pipelines)
ENTRYPOINT []