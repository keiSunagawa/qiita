#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint "${endpoint}" --b64-cluster-ca "${certificate}" "${cluster_name}"
