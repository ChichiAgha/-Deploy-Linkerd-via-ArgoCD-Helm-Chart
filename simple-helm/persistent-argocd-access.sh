#!/bin/bash

echo "🚀 Starting persistent ArgoCD port forwarding..."
echo "Access ArgoCD at: https://localhost:9876"
echo "Press Ctrl+C to stop"

while true; do
    echo "$(date): Starting port forward..."
    kubectl port-forward svc/argocd-server -n argocd 9876:443
    echo "$(date): Port forward disconnected, restarting in 5 seconds..."
    sleep 5
done