#!/bin/bash

wget -q -O - https://get.docker.com/ | bash
/etc/init.d/docker start
docker network create --driver bridge --subnet=172.250.0.0/24 telemetry_nw
mkdir -p /var/lib/grafana
wget https://dl.influxdata.com/telegraf/releases/telegraf_1.3.0-1_amd64.deb
sudo dpkg -i telegraf_1.3.0-1_amd64.deb
cd /tmp/telemetry
git clone git@github.com:sn-pmay/telemetry.git
mv /tmp/telemetry/telegraf/
docker run -p 8086:8086 -v /var/lib/influxdb:/var/lib/influxdb --hostname influxdb --name influxdb --network=telemetry_nw --ip=172.250.0.100  influxdb
docker run -p 3000:3000 -v /var/lib/grafana --name grafana --hostname grafana --network=telemetry_nw --ip=172.250.0.101 grafana/grafana
