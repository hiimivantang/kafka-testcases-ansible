#!/bin/bash

cd "$(dirname "$0")"

#start consumer and then producer
ansible-playbook start_clients.yml -i hosts.yml

#TODO: you can try to do something smarter by searching for an online broker, then use it for collecting metrics
#collect test topic metrics from an online broker 
ansible-playbook collect_metrics.yml -i hosts.yml -l node-1

#simulate failure for dc-1
ansible-playbook simulate_stop.yml -i hosts.yml -l dc-1

echo "sleeping for 1m"
sleep 1m

#TODO: you can try to do something smarter by searching for an online broker, then use it for collecting metrics
#collect test topic metrics from an online broker
ansible-playbook collect_metrics.yml -i hosts.yml -l node-1

#collect producer and consumer metrics
ansible-playbook collect_clients_metrics.yml -i hosts.yml
