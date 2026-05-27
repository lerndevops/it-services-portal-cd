# Kubernetes Deployment - Complete Guide

This directory contains Kubernetes deployment configurations for the IT Services Portal application using **Kustomize** as the primary tool.

### Directory Overview

```
k8s-deploy/
├── kustomize/                          ← CURRENT STRUCTURE (Use this!)
│   ├── base/                           (Shared resources)
│   │   ├── kustomization.yaml
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── configmap.yaml
│   │   └── secret.yaml
│   └── overlays/                       (Environment-specific patches)
│       ├── dev/
│       ├── uat/
│       └── prod/
```

## 🚀 Quick Start

### View Generated Manifests (Dry-Run)

```bash
# Dev environment
kubectl kustomize kustomize/overlays/dev

# UAT environment
kubectl kustomize kustomize/overlays/uat

# Production environment
kubectl kustomize kustomize/overlays/prod
```

### Deploy to Kubernetes

```bash
# Create namespaces first
kubectl create namespace dev uat prod

# Deploy applications
kubectl apply -k kustomize/overlays/dev -n dev
kubectl apply -k kustomize/overlays/uat -n uat
kubectl apply -k kustomize/overlays/prod -n prod
```

### Verify Deployments

```bash
# Check pod status
kubectl get pods -n dev -l app=it-services-portal
kubectl get pods -n uat -l app=it-services-portal
kubectl get pods -n prod -l app=it-services-portal

# View logs
kubectl logs -n dev -l app=it-services-portal -f
```

## 🎯 What is Kustomize?

**Kustomize** is Kubernetes' native configuration management tool (built into kubectl). It allows you to:

- ✅ Use plain YAML without templating
- ✅ Share common resources across environments
- ✅ Override values with strategic merge patches
- ✅ Maintain a single source of truth (base)

### How It Works

```
kustomize/base/
├── deployment.yaml    ← Common deployment
├── service.yaml       ← Common service
├── configmap.yaml     ← Common ConfigMap
├── secret.yaml        ← Common secrets
└── kustomization.yaml ← Base configuration

              ↓ Applied with patches from each overlay ↓

kustomize/overlays/dev/         kustomize/overlays/uat/         kustomize/overlays/prod/
├── kustomization.yaml          ├── kustomization.yaml          ├── kustomization.yaml
├── deployment-patch.yaml       ├── deployment-patch.yaml       ├── deployment-patch.yaml
└── configmap-patch.yaml        └── configmap-patch.yaml        └── configmap-patch.yaml

              ↓ Results in ↓

Final Deployment Manifests (dev/uat/prod)
```

## 📋 Environment Configuration

### Dev Environment
- **Namespace**: dev
- **Replicas**: 2
- **APP_ENV**: development
- **Image**: lerndevops/it-services-portal:latest
- **Debug**: false

### UAT Environment
- **Namespace**: uat
- **Replicas**: 2
- **APP_ENV**: uat
- **Image**: lerndevops/it-services-portal:latest
- **Debug**: false

### Production Environment
- **Namespace**: prod
- **Replicas**: 2
- **APP_ENV**: production
- **Image**: lerndevops/it-services-portal:latest
- **Debug**: false

## 🛠️ Common Tasks

### Update Image Version (All Environments)

1. Edit `kustomize/base/deployment.yaml`
2. Change image tag:
   ```yaml
   image: lerndevops/it-services-portal:v1.2.3
   ```
3. Redeploy:
   ```bash
   kubectl apply -k kustomize/overlays/dev -n dev
   kubectl apply -k kustomize/overlays/uat -n uat
   kubectl apply -k kustomize/overlays/prod -n prod
   ```

### Increase Replicas for Production Only

1. Edit `kustomize/overlays/prod/deployment-patch.yaml`
2. Add replicas:
   ```yaml
   spec:
     replicas: 5
   ```
3. Redeploy:
   ```bash
   kubectl apply -k kustomize/overlays/prod -n prod
   ```

### Add a New Environment

1. Create overlay directory:
   ```bash
   mkdir kustomize/overlays/staging
   ```
2. Create `kustomization.yaml` (copy from dev and modify)
3. Create patch files (`deployment-patch.yaml`, `configmap-patch.yaml`)
4. Deploy:
   ```bash
   kubectl apply -k kustomize/overlays/staging -n staging
   ```

## 🧪 Testing & Validation

### Validate Configuration

```bash
# Check for syntax errors
kubectl kustomize kustomize/overlays/dev --validate=true

# Dry-run deployment
kubectl apply -k kustomize/overlays/dev -n dev --dry-run=client

# View specific resources
kubectl kustomize kustomize/overlays/dev | grep -A 10 "kind: Deployment"
```

### Compare Environments

```bash
# See differences between dev and prod
diff <(kubectl kustomize kustomize/overlays/dev) \
     <(kubectl kustomize kustomize/overlays/prod)
```

## 🔐 Security Notes

- Secrets are stored in `base/secret.yaml` (base64 encoded)
- Consider using sealed-secrets or external-secrets for production
- Ensure RBAC is properly configured in your cluster
- Use network policies to restrict pod communication

## 📖 Best Practices

1. **Base for Shared**: Put common resources in `kustomize/base/`
2. **Overlays for Differences**: Use overlays for environment-specific changes
3. **Version Control**: Commit all changes to git
4. **Document Changes**: Add comments to patch files
5. **Test Before Deploying**: Always use `kubectl kustomize` to preview
6. **Use Namespaces**: Deploy each environment to separate namespace
7. **Monitor After Deploy**: Check logs and metrics after deployment

## 🐛 Troubleshooting

### Resources not updating?
```bash
kubectl rollout restart deployment/it-services-portal -n dev
```

### Check deployment status
```bash
kubectl describe deployment it-services-portal -n dev
```

### View event logs
```bash
kubectl get events -n dev --sort-by='.lastTimestamp'
```

### Verify labels are correct
```bash
kubectl get pods -n dev --show-labels
```

## References

- Kustomize Documentation: https://kustomize.io/
- kubectl apply -k: https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/
- Strategic Merge Patch: https://kubernetes.io/docs/tasks/manage-kubernetes-objects/declarative-config/#how-to-structure-your-resource-definitions
