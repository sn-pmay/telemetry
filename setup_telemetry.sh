#!/bin/bash

machine=$(uname -m)
if [ $machine -ne "x86_64"]; then
	echo "Only x86_64 is supported for now."
	exit 1
fi # if [ $machine -ne "x86_64"]

wget -q -O - https://get.docker.com/ | bash
/etc/init.d/docker start
docker network create --driver bridge --subnet=172.250.0.0/24 telemetry_nw
cd /tmp
mkdir -p /var/lib/grafana
wget https://dl.influxdata.com/telegraf/releases/telegraf_1.3.0-1_amd64.deb
sudo dpkg -i telegraf_1.3.0-1_amd64.deb
git clone https://github.com/sn-pmay/telemetry.git
mv /tmp/telemetry/telegraf/telegraf/* /etc/telegraf
/etc/init.d/telegraf restart
mv /tmp/telemetry/influxdb/ /etc/
docker run -d p 8086:8086 -v /var/lib/influxdb:/var/lib/influxdb -v /etc/influxdb:/etc/influxdb --hostname influxdb --name influxdb --network=telemetry_nw --ip=172.250.0.100  influxdb
docker run -d p 3000:3000 -v /var/lib/grafana --name grafana --hostname grafana --network=telemetry_nw --ip=172.250.0.101 grafana/grafana
# TODO: Need to:
# Setup Grafana auth
curl -X POST --silent --header "Content-Type: application/json" -d @grafana/datasource.json http://admin:admin@172.250.0.101:3000/api/datasources|python -mjson.tool
curl -X POST --silent --header "Content-Type: application/json" -d @/tmp/telemetry/grafana/system-state.json http://admin:admin@act-5812:3000/api/dashboards/db|python -mjson.tool
curl -X POST --silent --header "Content-Type: application/json" -d @/tmp/telemetry/grafana/flexswitch-processes-system-state.json http://admin:admin@act-5812:3000/api/dashboards/db|python -mjson.tool