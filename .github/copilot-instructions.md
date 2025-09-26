# Copilot Instructions for Linkerd ArgoCD Deployment

## Architecture Overview

This project deploys **Linkerd service mesh** via **ArgoCD** using a **GitOps** approach with **Helm charts** and **Kustomize overlays**. The architecture follows a multi-environment pattern with base configurations and environment-specific overlays.

### Key Components
- **ArgoCD Applications**: Declarative app definitions for dev/staging/prod environments
- **Kustomize Base**: Common Linkerd configuration in `overlays/linkered/base/`
- **Environment Overlays**: Environment-specific customizations in `dev/`, `staging/`, `prod/`
- **Helm Integration**: Uses Kustomize `helmCharts` to deploy official Linkerd charts

## Project Structure Pattern

```
Platform-Tools/argos-cd/
├── apps/                           # ArgoCD Application manifests
│   ├── linkered-dev-app.yml
│   ├── linkered-stage-app.yml
│   └── linkered-prod-app.yml
└── overlays/linkered/              # Kustomize structure
    ├── base/                       # Base Linkerd configuration
    │   ├── kustomization.yaml      # Main Kustomize config
    │   ├── values.yaml             # Linkerd control-plane values
    │   ├── chart-values-common.yaml # Linkerd CRDs values
    │   ├── namespace.yaml          # Linkerd namespace
    │   └── rolebinding-*.yaml      # RBAC configurations
    └── {dev,staging,prod}/         # Environment overlays
        ├── kustomization.yml       # Environment-specific patches
        └── values.{env}.yaml       # Environment-specific Helm values
```

## Helm-via-Kustomize Pattern

This project uses **Kustomize helmCharts** (not direct Helm) to deploy Linkerd:

1. **CRDs First**: `linkerd-crds` chart deployed before control plane
2. **Control Plane**: `linkerd-control-plane` chart with custom values
3. **Namespace Management**: Explicit namespace creation via resources
4. **RBAC**: Platform admin role bindings for cluster access

### Critical Configuration in base/kustomization.yaml
- Uses `helmCharts` field to reference official Linkerd Helm repository
- Deploys to `linkerd` namespace consistently
- Separate `valuesFile` for CRDs vs control plane
- `disableNameSuffixHash: true` for predictable resource names

## Development Workflows

### Adding New Environments
1. Create new directory under `overlays/linkered/{env}/`
2. Add `kustomization.yml` with base reference and patches
3. Create environment-specific `values.{env}.yaml`
4. Create corresponding ArgoCD app in `apps/linkered-{env}-app.yml`

### Updating Linkerd Version
- Pin specific versions in `helmCharts.version` fields in base kustomization
- Test in dev environment before promoting to staging/prod
- Update both `linkerd-crds` and `linkerd-control-plane` versions together

### Environment-Specific Customizations
- Use Kustomize patches in overlay `kustomization.yml` files
- Override Helm values via environment-specific `values.{env}.yaml`
- Common RBAC and namespace configs stay in base

## ArgoCD Integration Points

- **App-of-Apps Pattern**: Expected but not yet implemented
- **Multi-Environment**: Separate ArgoCD applications per environment
- **Source Path**: Points to specific overlay directory (`overlays/linkered/{env}`)
- **Auto-Sync**: Typically enabled for GitOps workflows
- **Health Checks**: ArgoCD monitors Linkerd control plane health

## File Naming Conventions

- **ArgoCD Apps**: `linkered-{env}-app.yml` format
- **Kustomize Files**: `.yaml` for base, `.yml` for overlays
- **Values Files**: `values.{env}.yaml` for environment-specific Helm values
- **RBAC**: Descriptive names like `rolebinding-platform-admins.yaml`

## Common Operations

### Debugging Kustomize Output
```bash
kustomize build Platform-Tools/argos-cd/overlays/linkered/{env}/
```

### Validating Helm Values
```bash
helm template linkerd-control-plane https://helm.linkerd.io/stable -f values.yaml
```

### ArgoCD App Sync
Reference the specific overlay path in ArgoCD application source configuration.