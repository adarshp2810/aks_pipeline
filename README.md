# 🚀 AKS Pipeline Deployment - Node.js App

This project demonstrates how to build and deploy a simple Node.js application to Azure Kubernetes Service (AKS) using Azure Container Registry (ACR) and Docker.

* * *

## 🧱 Project Structure

```bash
aks_pipeline/
├── app.js            # Node.js HTTP server
├── Dockerfile        # Docker build file
├── manifests/
│   ├── deployment.yaml
│   └── service.yaml
└── README.md         # This file
```

* * *

## 📦 Application Code

### `app.js`

```javascript
const http = require('http');
const port = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' });
  res.end('Hello from AKS Pipeline! 🚀\n');
});

server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
```

* * *

## 🐳 Docker Configuration

### `Dockerfile`

```dockerfile
# Use Node base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy app code
COPY app.js .

# Expose port
EXPOSE 3000

# Start the server
CMD ["node", "app.js"]
```

* * *

## 📜 Kubernetes Manifests

### `manifests/deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: aks-store-demo
  labels:
    app: aks-store-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: aks-store-demo
  template:
    metadata:
      labels:
        app: aks-store-demo
    spec:
      containers:
        - name: aks-store-demo
          image: azureprojects123.azurecr.io/aks-store-demo:latest
          ports:
            - containerPort: 3000
```

### `manifests/service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: aks-store-demo-service
spec:
  type: LoadBalancer
  selector:
    app: aks-store-demo
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
```

* * *

## ⚙️ Deployment Steps

### 1\. **Build Docker Image**

```bash
docker build -t aks-store-demo:latest .
```

### 2\. **Tag and Push to Azure Container Registry (ACR)**

```bash
az acr login --name azureprojects123

docker tag aks-store-demo:latest azureprojects123.azurecr.io/aks-store-demo:latest

docker push azureprojects123.azurecr.io/aks-store-demo:latest
```

### 3\. **Apply Kubernetes Manifests**

```bash
kubectl apply -f manifests/deployment.yaml
kubectl apply -f manifests/service.yaml
```

### 4\. **Access Your Application**

```bash
kubectl get svc aks-store-demo-service
```

> Open the EXTERNAL-IP in browser:  
> Example: `http://135.235.183.70`  
> You should see:
> 
> ```
> Hello from AKS Pipeline! 🚀
> ```

* * *

## 🧹 Cleanup Resources (Avoid Charges)

```bash
# Delete deployment and service
kubectl delete -f manifests/deployment.yaml
kubectl delete -f manifests/service.yaml

# Optional: Delete ACR and AKS
az aks delete --name <your-aks-name> --resource-group <your-rg> --yes --no-wait
az acr delete --name azureprojects123 --resource-group <your-rg> --yes
```

* * *

## ✅ Troubleshooting

* *   **ImagePullBackOff**: Make sure image was tagged and pushed to ACR correctly.
*     
* *   **ERR\_CONNECTION\_TIMED\_OUT**: The container might be listening on the wrong port. Ensure:
*     
*     * *   `app.js` listens on port 3000
*     * *   `Dockerfile` exposes port 3000
*     * *   Deployment's `containerPort` is 3000
*     * *   Service's `targetPort` is 3000
* *   **ACR Auth Issues**: Ensure AKS has pull permissions from ACR or use `az aks update --attach-acr`.
*     

* * *

## 👨‍💻 Author

Made by Adarsh Pawar using Azure, GITHUB
