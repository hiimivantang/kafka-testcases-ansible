# kafka-testcases-ansible

This repository contains the Ansible playbooks which you can use for:
* simulating node/rack/dc failures
* collecting topic-partition metrics such as current leader, preferred leader, ISR count, etc.
* automatically start a set of consumer and producer, with JMX metrics enabled
* collecting key client metrics for data quality checks, e.g. how many messages produce vs how many messages consumed


## Requirements
1. Ansible installed on control node
2. Specify all the brokers and client hostnames in the hosts.yml. E.g.:
```yaml
[node-1]
ip-10-0-0-218.ap-southeast-1.compute.internal

[node-2]
ip-10-0-0-199.ap-southeast-1.compute.internal

[node-3]
ip-10-0-0-221.ap-southeast-1.compute.internal

[node-4]
ip-10-0-0-198.ap-southeast-1.compute.internal

[client]
ip-10-0-0-232.ap-southeast-1.compute.internal

[broker-group-1:children]
node-1
node-2

[broker-group-2:children]
node-3
node-4

[dc-1:children]
broker-group-1

[dc-2:children]
broker-group-2
```


## How does it work?
By making use of variables to group specific brokers together in the `host.yml` file, you will be able to simulate rack and/or DC failures based on those variables.

For e.g.:
```
ansible-playbook simulate_stop.yml -i hosts.yml -l dc-1
```



## Usage example

Treat the following Ansible playbooks as building blocks for testing your Kafka cluster:

```
.
├── collect_clients_metrics.yml
├── collect_metrics.yml
├── simulate_start.yml
├── simulate_stop.yml
├── start_clients.yml
├── stop_clients.yml
```

See `sample_test.sh` for a sample bash script to simulate DC failure:
```bash
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
```


## FAQ

*How does `simulate_stop.yml` playbook simulate broker failures?* 

It searches for `confluent-server`'s pid then sends a `SIGKILL`.

Why is there a custom producer in this repo?

Modification was made to the `kafka-producer-perf-test` codes to prevent producer from closing when it is done producing all so that JMX metrics can be collected. It also introduces a new argument `--deterministic` to allow deterministic producer benchmarking, i.e. reading the payload row by row as opposed to randomly.


Why do you need an Ansible playbook just for starting a producer and consumer?

The playbook resets the consumer group offset to the latest, and kills any running test clients to ensure that each test starts with a clean slate.
It also copies the custom producer required to your client node.
