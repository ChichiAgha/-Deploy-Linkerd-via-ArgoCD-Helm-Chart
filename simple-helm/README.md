# Linkerd ArgoCD Helm Chart Deployment

This repository contains the GitOps configuration for deploying Linkerd service mesh via ArgoCD using Helm charts and Kustomize overlays.

## Architecture

- **ArgoCD**: GitOps continuous delivery
- **Linkerd**: Service mesh for zero-trust networking
- **Helm**: Package manager for Kubernetes
- **Kustomize**: Configuration management with environment overlays

## Structure

```
Platform-Tools/argos-cd/
├── apps/                    # ArgoCD Application definitions
├── overlays/linkered/       # Kustomize overlays
│   ├── base/               # Base Linkerd configuration
│   ├── dev/                # Development environment
│   ├── staging/            # Staging environment
│   └── prod/               # Production environment
```

## Deployment

1. ArgoCD watches this repository
2. Applications are deployed to respective environments
3. Linkerd provides service mesh capabilities

## Environments

- **Dev**: Lower resource limits for cost optimization
- **Staging**: Production-like configuration for testing
- **Prod**: Full production resources and settings