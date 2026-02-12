#!/bin/bash
set -euo pipefail

# Color-coded output
log_info() { echo -e "\033[1;34m[INFO]\033[0m $1"; }
log_success() { echo -e "\033[1;32m[SUCCESS]\033[0m $1"; }
log_error() { echo -e "\033[1;31m[ERROR]\033[0m $1"; }

# Usage message
usage() {
  echo "Usage: $0 [--env ENV] [--version VERSION] [--dry-run] [-h|--help]"
  echo "Options:"
  echo "  --env ENV         Deployment environment (dev, staging, prod)"
  echo "  --version VERSION Application version to deploy (default: latest git tag)"
  echo "  --dry-run         Simulate deployment without making changes"
  echo "  -h, --help        Show this help message"
  exit 1
}

# Default variables
ENV="dev"
VERSION=$(git describe --tags --always || echo "latest")
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --env)
      ENV="$2"
      shift 2
      ;;
    --version)
      VERSION="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      log_error "Unknown option: $1"
      usage
      ;;
  esac
done

# Check prerequisites
check_prerequisites() {
  log_info "Checking prerequisites..."
  for cmd in docker kubectl az; do
    if ! command -v $cmd &> /dev/null; then
      log_error "Required tool '$cmd' is not installed."
      exit 1
    fi
  done
  log_success "All prerequisites are met."
}

# Build Docker image
build_image() {
  log_info "Building Docker image..."
  IMAGE_NAME="my-django-app:${VERSION}"
  docker build -t "$IMAGE_NAME" .
  log_success "Docker image built: $IMAGE_NAME"
}

# Push Docker image to Azure Container Registry
push_image() {
  log_info "Pushing Docker image to Azure Container Registry..."
  ACR_NAME="myacr"
  az acr login --name "$ACR_NAME"
  IMAGE_NAME="my-django-app:${VERSION}"
  docker tag "$IMAGE_NAME" "$ACR_NAME.azurecr.io/$IMAGE_NAME"
  docker push "$ACR_NAME.azurecr.io/$IMAGE_NAME"
  log_success "Docker image pushed: $ACR_NAME.azurecr.io/$IMAGE_NAME"
}

# Deploy to Kubernetes
deploy_kubernetes() {
  log_info "Deploying to Kubernetes..."
  az aks get-credentials --resource-group my-resource-group --name my-aks-cluster
  kubectl apply -f k8s/deployment.yaml
  kubectl apply -f k8s/service.yaml
  log_success "Deployment applied to Kubernetes."
}

# Run health check
run_healthcheck() {
  log_info "Running health check..."
  HEALTH_URL="http://$(kubectl get svc my-django-app-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')/health"
  for i in {1..10}; do
    if curl -fs "$HEALTH_URL" &> /dev/null; then
      log_success "Health check passed."
      return
    fi
    sleep 5
  done
  log_error "Health check failed."
  rollback
}

# Rollback deployment
rollback() {
  log_info "Rolling back to previous version..."
  kubectl rollout undo deployment my-django-app
  log_success "Rollback completed."
  exit 1
}

# Main deployment process
main() {
  log_info "Starting deployment for environment: $ENV, version: $VERSION"
  check_prerequisites
  build_image
  push_image
  deploy_kubernetes
  run_healthcheck
  log_success "Deployment completed successfully."
}

# Dry-run mode
if $DRY_RUN; then
  log_info "Dry-run mode enabled. No changes will be made."
else
  main
fi