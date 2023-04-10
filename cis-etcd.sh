#!/bin/bash
#cis-etcd.sh

#total_fail=$(kube-bench run --targets etcd  --version 1.15 --check 2.2 --json | jq .[].total_fail)
total_fail=$(docker run --pid=host -v /etc:/etc:ro -v /var:/var:ro -v $(which kubectl):/usr/local/mount-from-host/bin/kubectl -v ~/.kube:/.kube -e KUBECONFIG=/.kube/config -t docker.io/aquasec/kube-bench:latest run ectd --version 1.20 --check 2.2 --json | jq '.Totals.total_fail')
fail_result=$(docker run --pid=host -v /etc:/etc:ro -v /var:/var:ro -v $(which kubectl):/usr/local/mount-from-host/bin/kubectl -v ~/.kube:/.kube -e KUBECONFIG=/.kube/config -t docker.io/aquasec/kube-bench:latest run ectd --version 1.20 --check 2.2)
if [[ "$total_fail" -ne 0 ]];
        then
                echo "CIS Benchmark Failed ETCD while testing for 2.2"
                exit 1;
        else
                echo "CIS Benchmark Passed for ETCD - 2.2"
                echo $fail_result 
fi;