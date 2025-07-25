# App Url : 
   - http://af8f8f7f3d0654858a2e8c776621d63e-449083115.us-east-1.elb.amazonaws.com/

# Eyego Task

A simple project that deploys a Node.js app returning "Hello Eyego" to an AWS EKS cluster. 
The setup is modular for easy migration to GCP (GKE) or Alibaba Cloud (ACK).

## Steps

1.Setup aws eks cluster using terraform
2.Create node.js app
3.Dockerize the app
4.Create an ecr repository named `eyego-app-img`.
5.Build and push the image
6.Create kubernetes manifests
   - eyego-deployment.yaml: 
        - Defines deployment with 2 replicas.
   - eyego-service.yaml: 
        - Exposes the app using a LoadBalancer service.
6.Deploy to eks
   - Applied manifests to the cluster:
        kubectl apply -f k8s/eyego-deployment.yaml
        kubectl apply -f k8s/eyego-service.yaml
   - Retrieved the external IP:
        kubectl get svc eyego-service
7.Set Up CI/CD with GitHub Actions
   - Create .github/workflows/ci-cd.yml to:
        - Build the Docker image.
        - Push to AWS ECR.
        - Deploy to AWS EKS automatically on pushes to main.

8.Push project to GitHub
   - Initialized a GitHub repo.
   - Pushed the entire project.

---

## Migration Notes to GCP or Alibaba Cloud

1.Setup GCP or Alibaba Cloud Cluster
- GCP:  
  - Push images to Google Container Registry or Artifact Registry.
  - Update kubectl context using "gcloud container clusters get-credentials".
- Alibaba Cloud:  
  - Push images to Alibaba Container Registry.
  - Update kubeconfig using aliyun cs "DescribeClusterUserKubeconfig".

Kubernetes manifests remain the same; only the container registry and kubeconfig commands change.

---

## Access the App

access the app using the EXTERNAL-IP of "eyego-service":

App Url : http://af8f8f7f3d0654858a2e8c776621d63e-449083115.us-east-1.elb.amazonaws.com/
