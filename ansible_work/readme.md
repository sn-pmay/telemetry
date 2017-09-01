For now, this setup in two parts:

* `docker.yml` - Will try to:
** *Note* - Relies on the device being able to reach the Intarwebz for the Docker keys/repo, pip-based installs of dependencies, and docker images.
** Get docker-engine (+friends/dependencies) installed on the host, including Ansible-specific dependencies (there is an aspect of a catch-22, and it's not lost on me :) )
** Creates a new network bridge named 'telemetry_nw'
** Creates and starts up the InfluxDB container (default retention: 168h aka 7d), port 8086
** Creates and starts up the Grafana container, port 3000

* `telemetry.yml` 
** Installs telegraf (custom compiled with a SnapRoute-specific plugin)
** Installs telegraf config(s)
*** Output to both a local InfluxDB instance, and a remote aggregating one
*** todo: Make the InfluxDB aggregating server a variable-based config
** Installs a datasource into Grafana for the local telemetry
** Installs a set of dashboards into Grafana as a starting point

