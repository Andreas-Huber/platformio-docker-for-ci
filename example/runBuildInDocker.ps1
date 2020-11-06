# Runs the PlatformIO build with the latest image form docker hub.
docker run -v ${pwd}:/opt/build --name pio-build infinitecoding/platformio-for-ci:latest platformio run -d /opt/build/.
docker rm pio-build