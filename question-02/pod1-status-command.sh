#!/bin/bash
# Expected answer - Pod status command
kubectl -n default describe pod pod1 | grep -i status: