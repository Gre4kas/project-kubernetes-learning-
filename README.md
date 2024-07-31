# Project Kubernetes Learning

Welcome to the **Project Kubernetes Learning** repository! This project serves as a personal learning playground for exploring key DevOps technologies such as Kubernetes, Docker, CI/CD pipelines, and monitoring tools. As an aspiring DevOps engineer, this project is an opportunity to demonstrate my growing knowledge and skills in these areas through a hands-on pet project.

## Table of Contents

- [Project Kubernetes Learning](#project-kubernetes-learning)
  - [Table of Contents](#table-of-contents)
  - [About the Project](#about-the-project)
  - [Technologies Used](#technologies-used)
  - [Project Setup](#project-setup)
  - [Future Improvements](#future-improvements)

## About the Project

The primary goal of this project is to provide a practical learning environment for using Kubernetes and associated tools. You'll explore concepts like container orchestration, continuous integration and deployment (CI/CD), and monitoring. The setup is based on K3s, a lightweight Kubernetes distribution, to simplify the learning process while still providing a robust platform for experimentation.

## Technologies Used

This project utilizes a range of modern DevOps tools:

- **K3s**: A lightweight Kubernetes distribution for clusters.
- **Kubernetes**: An open-source platform for managing containerized workloads and services.
- **Docker**: A platform for developing, shipping, and running applications in containers.
- **Grafana**: An analytics and monitoring platform.
- **Prometheus**: A monitoring system and time series database.
- **ArgoCD**: A declarative, GitOps continuous delivery tool for Kubernetes.
- **GitHub Actions**: A CI/CD platform that allows you to automate your workflows.

## Project Setup

To set up this project locally, follow these steps:

1. **Install K3s**:
   ```bash
   curl -sfL https://get.k3s.io | sh -

2. **Clone the repository:**
   ```bash
   git clone https://github.com/Gre4kas/project-kubernetes-learning-.git
   cd project-kubernetes-learning-
3. **Install ArgoCD:**
   - To install ArgoCD, follow these steps:
   
   1. **Create the ArgoCD namespace:**
      ```bash
      kubectl create namespace argocd
      ```

   2. **Install ArgoCD using the provided manifests:**
      ```bash
      kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
      ```

   3. **Access the ArgoCD UI:**
      - Forward the `argocd-server` service to a local port:
        ```bash
        kubectl port-forward svc/argocd-server -n argocd 8080:443
        ```
      - Access the ArgoCD UI at `https://localhost:8080`.

   4. **Login to ArgoCD:**
      - Retrieve the initial password:
        ```bash
        kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
        ```
      - Login using the username `admin` and the retrieved password.

   For more detailed instructions, refer to the [ArgoCD documentation](https://argo-cd.readthedocs.io/en/stable/getting_started/).

4. **Install Grafana and Prometheus:**

   To set up monitoring for your Kubernetes cluster, install Prometheus and Grafana:

   1. **Install Prometheus:**
      - Add the Prometheus Helm repository:
        ```bash
        helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
        helm repo update
        ```
      - Install Prometheus using Helm:
        ```bash
        helm install prometheus prometheus-community/prometheus \
          --namespace monitoring --create-namespace
        ```

   2. **Install Grafana:**
      - Add the Grafana Helm repository:
        ```bash
        helm repo add grafana https://grafana.github.io/helm-charts
        helm repo update
        ```
      - Install Grafana using Helm:
        ```bash
        helm install grafana grafana/grafana \
          --namespace monitoring
        ```

   3. **Access Grafana:**
      - Forward the Grafana service to a local port:
        ```bash
        kubectl port-forward svc/grafana -n monitoring 3000:80
        ```
      - Access the Grafana dashboard at `http://localhost:3000`.
      - Default login: `admin` / `prom-operator`.

   4. **Add Prometheus Data Source in Grafana:**
      - Once logged in to Grafana, add Prometheus as a data source using the Prometheus server URL (e.g., `http://prometheus-server.monitoring.svc.cluster.local`).

   For more detailed setup and configuration options, refer to the [Prometheus documentation](https://prometheus.io/docs/introduction/overview/) and [Grafana documentation](https://grafana.com/docs/grafana/latest/getting-started/).

5. **Deploy ArgoCD Pipeline:**

   To deploy your applications using ArgoCD, follow these steps:

   1. **Apply the ArgoCD Pipeline Configuration:**
      - Use the following command to deploy your applications via ArgoCD using the configuration specified in the `argocd-pipeline.yaml` file:
        ```bash
        kubectl apply -f kubernetes/argocd/argocd-pipeline.yaml
        ```

   2. **Monitor Deployment Status:**
      - You can monitor the status of your applications in the ArgoCD UI, which can be accessed at `https://localhost:8080` after port-forwarding as described earlier.

   3. **Check Application Sync:**
      - Ensure that the applications are synchronized and in a healthy state. If there are any issues, ArgoCD will provide details and logs to help you troubleshoot.

   For more information on managing applications with ArgoCD, refer to the [ArgoCD documentation](https://argo-cd.readthedocs.io/en/stable/user-guide/).
6. **Automated Deployment with GitHub Actions:**

   This project uses GitHub Actions to automate the process of building Docker images and deploying them via ArgoCD. The workflow triggers on every push to the repository, performing the following steps:

   1. **Build and Push Docker Image:**
      - When code is pushed to the repository, GitHub Actions workflow is triggered to build a Docker image using the Dockerfile in the repository.
      - The workflow then tags the image with a unique identifier (e.g., the commit SHA or build number) and pushes it to a specified container registry (like Docker Hub or GitHub Container Registry).

   2. **Update Image Tag in `argocd-pipeline.yaml`:**
      - After successfully pushing the new image, the workflow updates the image tag in the `argocd-pipeline.yaml` file. This ensures that ArgoCD deploys the latest version of the application.

   3. **Deploy Updated Application:**
      - ArgoCD detects the changes in the `argocd-pipeline.yaml` file and automatically updates the deployed application to use the new Docker image, ensuring that the latest code changes are live.

   For detailed setup and customization of the GitHub Actions workflow, you can refer to the `.github/workflows/` directory in the repository. This setup ensures continuous integration and continuous deployment (CI/CD) for your project, streamlining the development process.

## Future Improvements

As part of my continuous learning journey, I plan to further enhance this project with the following improvements:

1. **Upgrade ArgoCD Deployment to Use Helm Charts:**
   - Transitioning from static YAML files to Helm charts will enable more flexible and maintainable deployments, leveraging Helm's templating and versioning capabilities.

2. **Set Up Centralized Logging with Loki:**
   - Adding Loki for centralized logging will enhance the observability of the system, providing a scalable solution for log management alongside the existing monitoring setup with Grafana and Prometheus.

These enhancements will not only improve the functionality of the project but also help me deepen my understanding of advanced DevOps practices.
