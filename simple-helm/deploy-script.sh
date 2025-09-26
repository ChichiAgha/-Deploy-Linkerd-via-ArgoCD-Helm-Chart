#!/bin/bash

echo "🚀 Starting Linkerd deployment via ArgoCD..."

# Step 1: Create ArgoCD namespace and install ArgoCD
echo "📦 Installing ArgoCD..."
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
echo "⏳ Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=available --timeout=600s deployment/argocd-server -n argocd

# Step 2: Get ArgoCD admin password
echo "🔑 Getting ArgoCD admin password..."
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "ArgoCD Admin Password: $ARGOCD_PASSWORD"

# Step 3: Port forward ArgoCD UI (run in background)
echo "🌐 Setting up port forwarding to ArgoCD UI..."
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
PORT_FORWARD_PID=$!

echo "✅ ArgoCD is now accessible at: https://localhost:8080"
echo "   Username: admin"
echo "   Password: $ARGOCD_PASSWORD"

# Step 4: Apply ArgoCD Applications for Linkerd
echo "🔄 Deploying Linkerd ArgoCD Applications..."

# Note: You'll need to update the Git repo URL in your app files first
echo "⚠️  IMPORTANT: Update the Git repository URLs in your ArgoCD application files"
echo "   Current repo: https://git.edusuc.net/WEBFORX/ArgoCD-gitops"
echo "   Update to your actual Git repository URL"

read -p "Press Enter once you've updated the Git URLs in the app files..."

# Apply the ArgoCD applications
kubectl apply -f Platform-Tools/argos-cd/apps/

echo "🎉 Deployment initiated! Check ArgoCD UI for status."
echo "To stop port forwarding: kill $PORT_FORWARD_PID"