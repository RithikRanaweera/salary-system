#!/bin/bash
set -e

echo "☸️  Deploying TechSalary to K8s..."

# ── 1. Build all images
echo "→ Building images..."
docker build -t diwangaamasith/salary-service:latest   ./services/salary-service
docker build -t diwangaamasith/identity-service:latest ./services/identity-service
docker build -t diwangaamasith/vote-service:latest     ./services/vote-service
docker build -t diwangaamasith/search-service:latest   ./services/search-service
docker build -t diwangaamasith/stats-service:latest    ./services/stats-service
docker build -t diwangaamasith/bff:latest              ./bff
docker build -t diwangaamasith/frontend:latest         ./frontend

# ── 2. Push to Docker Hub
echo "→ Pushing images to Docker Hub..."
docker push diwangaamasith/salary-service:latest
docker push diwangaamasith/identity-service:latest
docker push diwangaamasith/vote-service:latest
docker push diwangaamasith/search-service:latest
docker push diwangaamasith/stats-service:latest
docker push diwangaamasith/bff:latest
docker push diwangaamasith/frontend:latest

# ── 3. Apply namespaces
echo "→ Creating namespaces..."
kubectl apply -f k8s/00-namespaces.yaml

# ── 4. Apply configs and secrets
echo "→ Applying ConfigMaps and Secrets..."
kubectl apply -f k8s/01-configmap.yaml
kubectl apply -f k8s/02-secret.yaml
kubectl apply -f k8s/03-postgres-secret.yaml

# ── 5. Deploy Postgres
echo "→ Deploying PostgreSQL..."
kubectl apply -f k8s/data/postgres-pvc.yaml
kubectl apply -f k8s/data/postgres-init-configmap.yaml
kubectl apply -f k8s/data/postgres-deployment.yaml

# ── 6. Wait for Postgres
echo "→ Waiting for Postgres..."
kubectl wait --for=condition=ready pod \
  -l app=postgres -n data --timeout=120s

# ── 7. Deploy all app services
echo "→ Deploying app services..."
kubectl apply -f k8s/app/identity-service-deployment.yaml
kubectl apply -f k8s/app/salary-service-deployment.yaml
kubectl apply -f k8s/app/vote-service-deployment.yaml
kubectl apply -f k8s/app/search-service-deployment.yaml
kubectl apply -f k8s/app/stats-service-deployment.yaml
kubectl apply -f k8s/app/bff-deployment.yaml
kubectl apply -f k8s/app/frontend-deployment.yaml

# ── 8. Apply Ingress
echo "→ Applying Ingress..."
kubectl apply -f k8s/ingress.yaml

# ── 9. Wait for core services
echo "→ Waiting for services to be ready..."
kubectl wait --for=condition=ready pod -l app=identity-service -n app --timeout=120s
kubectl wait --for=condition=ready pod -l app=salary-service   -n app --timeout=120s
kubectl wait --for=condition=ready pod -l app=bff              -n app --timeout=120s
kubectl wait --for=condition=ready pod -l app=frontend         -n app --timeout=120s

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📋 Status:"
kubectl get pods -n data
kubectl get pods -n app
kubectl get ingress -n app
echo ""
echo "▶️  Add to /etc/hosts if not already:"
echo "   127.0.0.1  techsalary.local"
echo ""
echo "▶️  Open: http://techsalary.local"
