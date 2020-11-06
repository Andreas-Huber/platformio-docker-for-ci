docker build --tag pio-docker:latest ../
docker run -v ${pwd}:/opt/build --name pio-build pio-docker:latest platformio run -d /opt/build/.
docker rm pio-build