ansible-playbook -s rsyslog.yaml --extra-vars "syslog_aggregator=192.168.100.73" -i nmap_out -u root -k
