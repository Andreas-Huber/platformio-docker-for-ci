# PlatformIO Continuous Integration Docker Image

[![](https://img.shields.io/docker/v/infinitecoding/platformio-for-ci?style=for-the-badge)](https://cloud.docker.com/repository/docker/infinitecoding/platformio-for-ci/ "View on Docker Hub")
[![](https://img.shields.io/docker/image-size/infinitecoding/platformio-for-ci/latest?style=for-the-badge)](https://cloud.docker.com/repository/docker/infinitecoding/platformio-for-ci/ "View on Docker Hub")
[![](https://img.shields.io/docker/pulls/infinitecoding/platformio-for-ci?style=for-the-badge)](https://cloud.docker.com/repository/docker/infinitecoding/platformio-for-ci/ "View on Docker Hub")
[![](https://img.shields.io/github/license/Andreas-Huber/platformio-docker-for-ci?style=for-the-badge)](https://cloud.docker.com/repository/docker/infinitecoding/platformio-for-ci/ "View on Docker Hub")


This Docker image can be used to create PlatformIO CI-Builds with a build service that supports Docker containers. We tested the image with Azure Pipelines, but theoretically, it should work in GitLab CI, Circle CI, Travis CI etc.
The image does not contain an entry point, because the build runner executes the tasks inside the container.

[View it on Docker Hub](https://cloud.docker.com/repository/docker/infinitecoding/platformio-for-ci/)

# Azure Pipelines example

The following build script builds the hello world ESP32 firmware inside the *infinitecoding/platformio-for-ci* Docker container.

The folder structure of the built source code:
```
platformio.ini
helloworld/helloworld.ino
```

``` yaml
trigger:
- master

resources:
  containers:
  - container: platformio
    image: infinitecoding/platformio-for-ci:latest
    endpoint: dockerhub-infinite-coding

jobs:
- job: esp32_platformio
  displayName: "PlatformIO build"
  container: platformio
  pool:
    vmImage: ubuntu-18.04
  steps:
    - script: |
        rm -fdr bin
        mkdir bin
      displayName: 'Prepare output directories'      
    - script: platformio ci --build-dir="./bin" --keep-build-dir --project-conf=platformio.ini ./helloworld/
      displayName: 'Build firmware'
    - task: CopyFiles@2
      inputs:
        SourceFolder: $(Build.SourcesDirectory)/bin/.pio/build/esp32dev/
        Contents: 'firmware.bin'
        TargetFolder: $(Build.ArtifactStagingDirectory)
    - task: PublishBuildArtifacts@1
      inputs:
        ArtifactName: 'Firmware $(Build.BuildNumber)'
        PathtoPublish: $(Build.ArtifactStagingDirectory)
        publishLocation: Container
        TargetPath: .
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
