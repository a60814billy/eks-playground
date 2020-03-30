#!/bin/bash
set -ex
B64_CLUSTER_CA=${clusterCertificate}
API_SERVER_URL=${clusterEndpoint}
/etc/eks/bootstrap.sh ${clusterName} --kubelet-extra-args '${extraTag}' --b64-cluster-ca $B64_CLUSTER_CA --apiserver-endpoint $API_SERVER_URL
