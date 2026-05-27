# Quick Reference - Kustomize Commands

## View Generated Manifests

```bash
# Dev
kubectl kustomize kustomize/overlays/dev

# UAT
kubectl kustomize kustomize/overlays/uat

# Production
kubectl kustomize kustomize/overlays/prod
```

## Deploy Applications

```bash
# Create namespaces first
kubectl create namespace dev
kubectl create namespace uat
kubectl create namespace prod

# Deploy Dev
kubectl apply -k kustomize/overlays/dev -n dev

# Deploy UAT
kubectl apply -k kustomize/overlays/uat -n uat

# Deploy Production
kubectl apply -k kustomize/overlays/prod -n prod
```

## Verify Deployments

```bash
# Check dev deployment
kubectl get all -n dev -l app=it-services-portal

# Check uat deployment
kubectl get all -n uat -l app=it-services-portal

# Check prod deployment
kubectl get all -n prod -l app=it-services-portal

# Check pod status
kubectl get pods -n dev -l app=it-services-portal
```

## Update Deployments

```bash
# Update image in base (affects all environments)
# Edit: kustomize/base/deployment.yaml

# Update Dev replicas
# Edit: kustomize/overlays/dev/deployment-patch.yaml

# Rebuild and apply
kubectl apply -k kustomize/overlays/dev -n dev
```

## Delete Deployments

```bash
# Delete from Dev
kubectl delete -k kustomize/overlays/dev -n dev

# Delete from UAT
kubectl delete -k kustomize/overlays/uat -n uat

# Delete from Production
kubectl delete -k kustomize/overlays/prod -n prod
```

## Debugging

```bash
# View rendered manifests for a specific environment
kubectl kustomize kustomize/overlays/dev > /tmp/dev-manifests.yaml

# Validate Kustomization
kubectl apply -k kustomize/overlays/dev --dry-run=client

# Check differences between environments
diff <(kubectl kustomize kustomize/overlays/dev) <(kubectl kustomize kustomize/overlays/prod)
```

## File Locations

- **Base Resources**: `kustomize/base/`
  - Common resources for all environments
  - No environment-specific values

- **Dev Overlay**: `kustomize/overlays/dev/`
  - Dev-specific patches
  - Namespace: dev
  - Label: env=dev

- **UAT Overlay**: `kustomize/overlays/uat/`
  - UAT-specific patches
  - Namespace: uat
  - Label: env=uat

- **Prod Overlay**: `kustomize/overlays/prod/`
  - Production-specific patches
  - Namespace: prod
  - Label: env=production
