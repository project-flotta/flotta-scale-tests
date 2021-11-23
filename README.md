# k4e-scale
The purpose of this project is to test the scalability and performance of [k4e project](https://github.com/jakub-dzon/k4e-operator) using [JMeter](https://jmeter.apache.org).

## Installation
The test plan for testing k4e is using the [Parallel Sampling controller](https://github.com/Blazemeter/jmeter-bzm-plugins/blob/master/parallel/Parallel.md) that needs to be installed.
Instructions for installing plugins can be found on [here](https://jmeter-plugins.org/install/Install/).

## Running the test plan
Before the test can be run, the test plan needs to be prepared.
The following parameters need to be set:
* K8S_BEARER_TOKEN - the token is used to access the K8s API (see details below)
* HTTP_SERVER - K4E Server address
* HTTP_SERVER_PORT - K4E Server port (default: 8888)
* OCP_API_SERVER - K8S API server address
* OCP_API_SERVER_PORT - K8S API server port (default: 8443)
* NAMESPACE - K4E namespaces aren't supported yet, so the test will be run in the default namespace

After the test plan is prepared, the test can be run:
```bash
JVM_ARGS="-Xms1g -Xmx4g -XX:MaxMetaspaceSize=512m" $JMETER_HOME/bin/jmeter.sh -n -t ./test_plans/k4e_test_plan.jmx -l results.csv -e
```

## Test Plan
The [basic test plan](./test_plans/k4e_test_plan.jmx) runs the following scenario:
* Register an edge device
* Label the edge device
* Creates 10 edge deployments for the device
* In Loop:
  * Sends heartbeats to the server
  * Get updates from the server

## Creating a token for accessing K8S cluster
For **testing** purposes, we need to create a token for accessing K8S cluster via RESTFUL API.
Once the k4e-operator is deployed on the cluster, the following can be run to create a privileged token:
```bash
# Create a service account
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: k4e-scale-test
EOF

# Attach the service account to a privileged role
kubectl create clusterrolebinding k4e-scale-test-cluster-admin --clusterrole=cluster-admin --serviceaccount=default:k4e-scale-test

# Get the token
kubectl get secret $(kubectl get serviceaccount k4e-scale-test -o json | jq -r '.secrets[].name') -o yaml | grep " token:" | awk {'print $2'} |  base64 -d
```
