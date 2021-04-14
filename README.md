# kafka-testcases-ansible

This repository contains the Ansible playbooks which you can use for:
* simulating node/rack/dc failures
* collecting topic-partition metrics such as current leader, preferred leader, ISR count, etc.
* automatically start a set of consumer and producer, with JMX metrics enabled
* collecting key client metrics for data quality checks, e.g. how many messages produce vs how many messages consumed


## Requirements
1. Ansible installed on control node
2. Specify all the brokers in hosts.yml. E.g.:
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




## Usage




## FAQ
