FROM python:2.7-stretch

# Install PlatformIO, and it's newest available dependencies via pip.
RUN pip install -U PlatformIO==4.0.0

# Delete entrypoint of parent containers (required by Azure Pipelines)
ENTRYPOINT []