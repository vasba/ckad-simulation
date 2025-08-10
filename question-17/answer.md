# Answer - Question 17 | Network Policy
Answer
INFO: For learning NetworkPolicies check out https://editor.cilium.io. But you're not allowed to use it during the exam.

First we get an overview:
➜ k -n venus get all
NAMEREADYSTATUSRESTARTSAGEpod/api-5979b95578-gktxp1/1Running057spod/api-5979b95578-lhcl51/1Running057spod/frontend-789cbdc677-c9v8h1/1Running057spod/frontend-789cbdc677-npk2m1/1Running057spod/frontend-789cbdc677-pl67g1/1Running057spod/frontend-789cbdc677-rjt5r1/1Running057spod/frontend-789cbdc677-xgf5n1/1Running057sNAMETYPECLUSTER-IPEXTERNAL-IPPORT(S)AGE
service/apiClusterIP10.3.255.137<none>2222/TCP37s
service/frontendClusterIP10.3.255.135<none>80/TCP57s
...
(Optional) This is not necessary but we could check if the Services are working inside the cluster:
➜ k -n venus run tmp --restart=Never --rm -i --image=busybox -i -- wget -O- frontend:80
Connecting to frontend:80 (10.3.245.9:80)
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...
➜ k -n venus run tmp --restart=Never --rm --image=busybox -i -- wget -O- api:2222
Connecting to api:2222 (10.3.250.233:2222)
<html><body><h1>It works!</h1></body></html>
Then we use any frontend Pod and check if it can reach external names and the api Service:➜ k -n venus exec frontend-789cbdc677-c9v8h -- wget -O- www.google.com
Connecting to www.google.com (216.58.205.227:80)
-
100% |********************************| 12955
0:00:00 ETA
<!doctype html><html itemscope="" itemtype="http://schema.org/WebPage" lang="en"><head>
...
➜ k -n venus exec frontend-789cbdc677-c9v8h -- wget -O- api:2222
<html><body><h1>It works!</h1></body></html>
Connecting to api:2222 (10.3.255.137:2222)
-
100% |********************************|
45
0:00:00 ETA
...
We see Pods of frontend can reach the api and external names.
vim 20_np1.yaml
Now we head to https://kubernetes.io/docs, search for NetworkPolicy, copy the example code and adjust it to:
# 20_np1.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
name: np1
namespace: venus
spec:
podSelector:
matchLabels:
id: frontend
# label of the pods this policy should be applied on
policyTypes:
- Egress
# we only want to control egress
egress:
- to:
# 1st egress rule
- podSelector:
# allow egress only to pods with api label
matchLabels:
id: api
- ports:
# 2nd egress rule
- port: 53
# allow DNS UDP
protocol: UDP
- port: 53
# allow DNS TCP
protocol: TCP
Notice that we specify two egress rules in the yaml above. If we specify multiple egress rules then these are connected using a logical
OR. So in the example above we do:
allow outgoing traffic if
(destination pod has label id:api) OR ((port is 53 UDP) OR (port is 53 TCP))
Let's have a look at example code which wouldn't work in our case:# this example does not work in our case
...
egress:
- to:
# 1st AND ONLY egress rule
- podSelector:
# allow egress only to pods with api label
matchLabels:
id: api
ports:
# STILL THE SAME RULE but just an additional selector
- port: 53
# allow DNS UDP
protocol: UDP
- port: 53
# allow DNS TCP
protocol: TCP
In the yaml above we only specify one egress rule with two selectors. It can be translated into:
allow outgoing traffic if
(destination pod has label id:api) AND ((port is 53 UDP) OR (port is 53 TCP))
Apply the correct policy:
k -f 20_np1.yaml create
And try again, external is not working any longer:
➜ k -n venus exec frontend-789cbdc677-c9v8h -- wget -O- www.google.de
Connecting to www.google.de:2222 (216.58.207.67:80)
^C
➜ k -n venus exec frontend-789cbdc677-c9v8h -- wget -O- -T 5 www.google.de:80
Connecting to www.google.com (172.217.203.104:80)
wget: download timed out
command terminated with exit code 1
Internal connection to api work as before:
➜ k -n venus exec frontend-789cbdc677-c9v8h -- wget -O- api:2222
<html><body><h1>It works!</h1></body></html>
Connecting to api:2222 (10.3.255.137:2222)
-
100% |********************************|
45
0:00:00 ETA