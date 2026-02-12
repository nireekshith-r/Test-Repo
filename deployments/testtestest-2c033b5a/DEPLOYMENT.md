# Deployment Guide for Asdasd

## Overview
This guide provides instructions for deploying the `Asdasd` Python application using Azure Kubernetes Service (AKS). The application runs on port `8000` and includes a health check endpoint at `/health`.

## Prerequisites
Before deploying, ensure the following tools and permissions are available:
- **Docker**: Installed and configured.
- **kubectl**: Installed and configured for your AKS cluster.
- **Azure CLI**: Installed and authenticated.
- **Access to Azure resources**: Ensure you have permissions to manage the AKS cluster and ACR.

## Quick Start
1. Clone the repository: