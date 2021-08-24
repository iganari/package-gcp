# Optimizing IP address allocation

## CIDR ranges for Standard clusters

https://cloud.google.com/kubernetes-engine/docs/how-to/flexible-pod-cidr?hl=en

Maximum Pods per Node| CIDR Range per Node | Number of IP addresses
:- |:- |:-
8 |	/28 |	16
9 – 16 | /27 |	32
17 – 32 |	/26 |	64
33 – 64 |	/25 |	128
65 – 110 | /24 | 256


## CIDR settings for Autopilot cluster

+ Subnetwork range: /23
+ Cluster IPv4 CIDR (range for Pods): /17
+ Services IPv4 CIDR (range for Services): /22
