# PlatformIO Continuous Integration Docker Image

[![](https://img.shields.io/docker/v/infinitecoding/platformio-for-ci?style=for-the-badge)](https://cloud.docker.com/repository/docker/infinitecoding/platformio-for-ci/ "View on Docker Hub")
[![](https://img.shields.io/docker/image-size/infinitecoding/platformio-for-ci/latest?style=for-the-badge)](https://cloud.docker.com/repository/docker/infinitecoding/platformio-for-ci/ "View on Docker Hub")
[![](https://img.shields.io/docker/pulls/infinitecoding/platformio-for-ci?style=for-the-badge)](https://cloud.docker.com/repository/docker/infinitecoding/platformio-for-ci/ "View on Docker Hub")
[![](https://img.shields.io/github/license/Andreas-Huber/platformio-docker-for-ci?style=for-the-badge)](https://cloud.docker.com/repository/docker/infinitecoding/platformio-for-ci/ "View on Docker Hub")


This Docker image can be used to create PlatformIO CI-Builds with a build service that supports Docker containers. We tested the image with Azure Pipelines, but theoretically, it should work in GitLab CI, Circle CI, Travis CI etc.
The image does not contain an entry point, because the build runner executes the tasks inside the container.

[View it on Docker Hub](https://cloud.docker.com/repository/docker/infinitecoding/platformio-for-ci/)

# Azure Pipelines example

The following build script builds the project ESP32 firmware in the [example](example) folder withing the *infinitecoding/platformio-for-ci* Docker container with azure pipelines.


[![Build Status](https://infinite-coding.visualstudio.com/platformio-for-ci/_apis/build/status/Andreas-Huber.platformio-docker-for-ci?branchName=azure-pipelines)](https://infinite-coding.visualstudio.com/platformio-for-ci/_build/latest?definitionId=16&branchName=azure-pipelines)


**[example/azure-pipelines-example.yml](example/azure-pipelines-example.yml)**

``` yaml
trigger:
- azure-pipelines

pool:
  vmImage: 'ubuntu-latest'

resources:
  containers:
  - container: platformio
    image: infinitecoding/platformio-for-ci:latest
    endpoint: personal-docker-hub-connection

container: platformio
steps:

- script: platformio run -d ./example/
  displayName: 'Build firmware'

- task: CopyFiles@2
  inputs:
    SourceFolder: '$(Build.SourcesDirectory)/example/.pio/build/esp32dev/'
    Contents: 'firmware.bin'
    TargetFolder: '$(Build.ArtifactStagingDirectory)'

- task: PublishBuildArtifacts@1
  inputs:
    ArtifactName: 'Firmware $(Build.BuildNumber)'
    PathtoPublish: $(Build.ArtifactStagingDirectory)
    publishLocation: Container
    TargetPath: .
```

# Github Actions example

The following build script builds the project ESP32 firmware in the [example](example) folder withing the *infinitecoding/platformio-for-ci* Docker container with github actions.

![Example-CI](https://github.com/Andreas-Huber/platformio-docker-for-ci/workflows/Example-CI/badge.svg?branch=github-actions)

**[.github\workflows\platformio-example.yml](.github\workflows\platformio-example.yml)**

``` yaml
name: Example-CI

on:
  push:
    branches: [ github-actions ]

jobs:
  platformio-build:
    runs-on: ubuntu-latest
    container: infinitecoding/platformio-for-ci:latest

    steps:
      - uses: actions/checkout@v2

      - name: Build firmware
        run: platformio run -d ./example/

      - name: Upload firware artifact
        uses: actions/upload-artifact@v2
        with:
          name: firmware.elf
          path: example/.pio/build/esp32dev/firmware.elf
```

# Run the container locally

To test if the PlatformIO build works with the container, you can also run it locally.

## Linux & MAC
To build the project in the example folder on a UNIX system run the following commands.
Or run the [runBuildInDocker.sh](example/runBuildInDocker.sh) bash script.

``` bash
# Set the example project folder as working directory
cd example

# Run the build
docker run -v `pwd`:/opt/build --name pio-build infinitecoding/platformio-for-ci:latest platformio run -d /opt/build/.

# Delete the container
docker rm pio-build
```

## Windows
To build the project in the example folder on a Windows system run the following commands.
Or run the [runBuildInDocker.ps1](example/runBuildInDocker.ps1) PowerShell script.


``` powershell
# Set the example project folder as working directory
cd example

# Run the build
docker run -v ${pwd}:/opt/build --name pio-build infinitecoding/platformio-for-ci:latest platformio run -d /opt/build/.

# Delete the container
docker rm pio-build
```
