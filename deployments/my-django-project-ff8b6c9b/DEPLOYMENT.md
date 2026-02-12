# Deployment Guide for My-django-app

## Overview
This guide provides instructions to deploy the `My-django-app` Django application to an Azure Kubernetes Service (AKS) cluster.

## Prerequisites
1. **Tools Required**:
   - Docker
   - kubectl
   - Azure CLI (`az`)
2. **Access Requirements**:
   - Access to the Azure subscription and AKS cluster
   - Permissions to push images to Azure Container Registry (ACR)
3. **Environment Setup**:
   - Copy `.env.example` to `.env` and configure the required variables.

## Quick Start
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/nireekshith-r/Test-Repo.git
   cd Test-Repo
   ```
2. **Configure Environment**:
   ```bash
   cp .env.example .env
   # Edit .env with appropriate values
   ```
3. **Deploy Application**:
   ```bash
   ./scripts/deploy.sh --env prod --version v1.0.0
   ```

## Architecture
The application is deployed as a containerized service on AKS. It uses:
- Azure Container Registry (ACR) for storing Docker images.
- Kubernetes Deployment and Service for application orchestration.

## Deployment Options
- **Local Development**: Use `python manage.py runserver`.
- **Staging Deployment**: Run `./scripts/deploy.sh --env staging`.
- **Production Deployment**: Run `./scripts/deploy.sh --env prod`.

## Configuration
Refer to `.env.example` for all configurable environment variables.

## Operations
- **Scaling**:
  ```bash
  kubectl scale deployment my-django-app --replicas=20
  ```
- **Monitoring**:
  Use the configured monitoring URL in `.env`.
- **Access Logs**:
  ```bash
  kubectl logs deployment/my-django-app
  ```

## Troubleshooting
- **Health Check Failures**:
  - Verify the application logs using `kubectl logs`.
  - Check the health endpoint: `/health`.
- **Resource Constraints**:
  - Ensure sufficient CPU/Memory limits are configured in the Kubernetes deployment.

## Rollback
To rollback to the previous version:
```bash
kubectl rollout undo deployment my-django-app
```