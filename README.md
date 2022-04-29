# flotta-scale-tests
The purpose of this project is to test the scalability and performance of [project-flotta](https://github.com/project-flotta/flotta-operator) using [JMeter](https://jmeter.apache.org).

## Install OCP SNO cluster
Clone https://github.com/openshift/assisted-test-infra and see https://github.com/openshift/assisted-test-infra#single-node---bootstrap-in-place-with-assisted-service for instructions
Set the KUBECONFIG variable with the path where the kube config file is located.

Clone https://github.com/project-flotta/flotta-operator then generate and push docker image to your repository.
Run `TARGET=ocp IMG=<your image> make  ` to deploy flotta operator to your cluster.

Add entry to your /etc/hosts file with the IP address of the cluster (`oc get nodes -o wide`) with name project-flotta.io

## Running the test plan
Use [./scripts/run_test_plan.sh](./scripts/run_test_plan.sh) to run the test plan.
The script will create the required resources on the cluster for running the test.

```bash
export KUBECONFIG=path_to_kubeconfig
./scripts/run_test_plan.sh -t ./test_plans/flotta_test_plan.jmx \
                           -n 123 \
                           -d 1 \
                           -i 1 \
                           -p 1 \
                           -r 1 \
                           -s api.devicemgmt3.srv \
                           -g flotta-operator-controller-manager-flotta.apps.devicemgmt3.srv
```

## Test Plans
The [basic test plan](./test_plans/flotta_test_plan.jmx) runs the following scenario:
* For each edge device:
  * Register an edge device
  * Label the edge device
  * Create edge deployments for the device
  * In Loop:
    * Sends heartbeats to the server
    * Get updates from the server
  
