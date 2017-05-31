#!/bin/bash

wget -q -O - https://get.docker.com/ | bash
/etc/init.d/docker start
docker network create --driver bridge --subnet=172.250.0.0/24 telemetry_nw
mkdir -p /var/lib/grafana
wget https://dl.influxdata.com/telegraf/releases/telegraf_1.3.0-1_amd64.deb
sudo dpkg -i telegraf_1.3.0-1_amd64.deb
cd /tmp/telemetry
git clone https://github.com/sn-pmay/telemetry.git
mv /tmp/telemetry/telegraf/telegraf/* /etc/telegraf
mv /tmp/telemetry/influxdb/ /etc/
mv /tmp/telemetry/
docker run -d p 8086:8086 -v /var/lib/influxdb:/var/lib/influxdb -v /etc/influxdb:/etc/influxdb --hostname influxdb --name influxdb --network=telemetry_nw --ip=172.250.0.100  influxdb
docker run -d p 3000:3000 -v /var/lib/grafana --name grafana --hostname grafana --network=telemetry_nw --ip=172.250.0.101 grafana/grafana
# TODO: Need to:
# Setup Grafana auth
# Setup a Grafana datasource, pointing at http://172.250.0.1:8086
# Add the two dashboards.