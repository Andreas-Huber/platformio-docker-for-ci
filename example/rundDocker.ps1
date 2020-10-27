docker run -v ${pwd}:/opt/build --name prio-build infinitecoding/platformio-for-ci:latest platformio run -d /opt/build/.
docker rm pio-build