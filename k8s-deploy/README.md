# IT Services Portal Kubernetes Deployment

This directory contains Kubernetes manifests and Helm charts for deploying the IT Services Portal application across different environments (dev, uat, prod).

## Directory Structure

```
k8s-deploy/
├── charts/
│   └── it-services-portal/          # Shared Helm chart for all environments
│       ├── Chart.yaml               # Chart metadata
│       ├── values.yaml              # Default values
│       └── templates/               # Kubernetes templates
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── configmap.yaml
│           └── secret.yaml
└── releases/
    ├── dev/values.yaml              # Dev environment-specific values
    ├── uat/values.yaml              # UAT environment-specific values
    └── prod/values.yaml             # Prod environment-specific values
```

## Structure Overview

- **charts/**: Contains the reusable Helm chart with templated Kubernetes manifests
- **releases/**: Contains environment-specific `values.yaml` files that override defaults

## Prerequisites

- Helm 3.x installed
- kubectl configured for your cluster

## Usage

### Generate Manifests for Deployment

To generate Kubernetes manifests for a specific environment without deploying:

```bash
# Dev environment
helm template it-services-portal ./charts/it-services-portal -f ./releases/dev/values.yaml

# UAT environment
helm template it-services-portal ./charts/it-services-portal -f ./releases/uat/values.yaml

# Production environment
helm template it-services-portal ./charts/it-services-portal -f ./releases/prod/values.yaml
```

### Deploy to Kubernetes

To deploy the application to a specific environment:

```bash
# Dev environment
helm install it-services-portal ./charts/it-services-portal -f ./releases/dev/values.yaml -n dev-namespace

# UAT environment
helm install it-services-portal ./charts/it-services-portal -f ./releases/uat/values.yaml -n uat-namespace

# Production environment
helm install it-services-portal ./charts/it-services-portal -f ./releases/prod/values.yaml -n prod-namespace
```

### Upgrade Deployments

To upgrade an existing deployment:

```bash
helm upgrade it-services-portal ./charts/it-services-portal -f ./releases/dev/values.yaml -n dev-namespace
```

## Environment Customization

Each environment has its own `values.yaml` file that defines:

- **environment**: Environment label (dev, uat, production)
- **image**: Container image repository and tag
- **replicas**: Number of pod replicas
- **resources**: CPU and memory limits/requests
- **service**: Service type, port, and node port
- **config**: ConfigMap environment variables
- **secrets**: Base64-encoded secrets for database credentials

### Example: Modifying Dev Environment

Edit `./releases/dev/values.yaml` to change:

```yaml
replicas: 3                    # Increase replicas
config:
  APP_ENV: "development"       # Change app environment
  APP_DEBUG: "true"            # Enable debug mode
```

Then redeploy:

```bash
helm upgrade it-services-portal ./charts/it-services-portal -f ./releases/dev/values.yaml -n dev-namespace
```

## Chart Values Reference

### Top-level values

| Key | Type | Description |
|-----|------|-------------|
| environment | string | Environment name (dev, uat, production) |
| app | string | Application name |
| replicas | integer | Number of pod replicas |

### Image values

| Key | Type | Description |
|-----|------|-------------|
| image.repository | string | Container image repository |
| image.tag | string | Image tag |
| image.pullPolicy | string | Pull policy (IfNotPresent, Always) |

### Resources values

| Key | Type | Description |
|-----|------|-------------|
| resources.limits.cpu | string | CPU limit |
| resources.limits.memory | string | Memory limit |
| resources.requests.cpu | string | CPU request |
| resources.requests.memory | string | Memory request |

### Service values

| Key | Type | Description |
|-----|------|-------------|
| service.type | string | Service type (NodePort, ClusterIP, LoadBalancer) |
| service.port | integer | Service port |
| service.targetPort | integer | Target port on container |
| service.nodePort | integer | Node port (when type=NodePort) |

## Migration from Old Structure

The old environment-specific YAML files (deployment.yaml, service.yaml, etc.) have been preserved for reference but are no longer used. All configuration now goes through:

1. Chart templates in `charts/it-services-portal/templates/`
2. Environment-specific values in `releases/{env}/values.yaml`

## Best Practices

1. **Never modify chart templates** for environment-specific values - use `values.yaml` instead
2. **Keep defaults in `charts/it-services-portal/values.yaml`** for common values
3. **Only override in `releases/{env}/values.yaml`** for environment-specific differences
4. **Version your chart** in `Chart.yaml` when making template changes
5. **Use `helm template`** to preview changes before applying with `helm install/upgrade`

## Troubleshooting

### Validate chart syntax

```bash
helm lint ./charts/it-services-portal
```

### Dry-run deployment

```bash
helm install it-services-portal ./charts/it-services-portal -f ./releases/dev/values.yaml --dry-run --debug
```

### View rendered templates

```bash
helm template it-services-portal ./charts/it-services-portal -f ./releases/dev/values.yaml
```
