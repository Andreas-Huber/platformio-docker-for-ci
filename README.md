# PlatformIO Continuous Integration Docker Image

[![](https://images.microbadger.com/badges/version/infinitecoding/platformio-for-ci:4.0.0.svg)](https://cloud.docker.com/repository/docker/infinitecoding/platformio-for-ci/ "View on Docker Hub")
[![](https://images.microbadger.com/badges/image/infinitecoding/platformio-for-ci:4.0.0.svg)](https://microbadger.com/images/infinitecoding/platformio-for-ci:4.0.0 "View layers on microbadger.com")

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
    vmImage: ubuntu-16.04
  steps:
    - script: |
        rm -fdr bin
        mkdir bin
      displayName: 'Prepare output directories'      
    - script: platformio ci --build-dir="./bin" --keep-build-dir --project-conf=platformio.ini ./helloworld/
      displayName: 'Build firmware'
    - task: CopyFiles@2
      inputs:
        SourceFolder: $(Build.SourcesDirectory)/bin/.pioenvs/esp32dev/
        Contents: 'firmware.bin'
        TargetFolder: $(Build.ArtifactStagingDirectory)
    - task: PublishBuildArtifacts@1
      inputs:
        ArtifactName: 'Firmware $(Build.BuildNumber)'
        PathtoPublish: $(Build.ArtifactStagingDirectory)
        publishLocation: Container
        TargetPath: .
```