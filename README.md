# DevOps Ecommerce Project

## Project Overview

This is an Ecommerce Website project built using Java 21 and Maven 3.9.9, running on Tomcat 11. It uses Docker and Kubernetes for containerization and orchestration. The CI/CD pipeline is implemented with Jenkins, and JFrog Artifactory is used as the artifact repository.

The project demonstrates a full DevOps lifecycle with source code management, automated build and test, container-based deployment, and infrastructure automation using Ansible.

---

## Features
- Java-based backend with Servlets and JSP frontend.
- Frontend includes HTML, CSS, and JavaScript.
- Containerized using Docker, deployed on Kubernetes.
- Automated CI/CD pipelines with Jenkinsfiles for build, test, and deploy.
- Configuration management and deployment automation via Ansible.
- Integration with JFrog Artifactory for artifact management.
- Sample test cases included.

---

## Prerequisites

| Software          | Version          |  
|-------------------|------------------|  
| ![Java](https://img.shields.io/badge/Java-21-blue) | 21               |  
| ![Maven](https://img.shields.io/badge/Maven-3.9.9-brightgreen) | 3.9.9            |  
| ![Tomcat](https://img.shields.io/badge/Tomcat-11.0.0-orange) | 11.0.0           |  
| ![JFrog](https://img.shields.io/badge/JFrog-7.17.7-darkgreen) | 7.17.7           |  
| ![Git](https://img.shields.io/badge/Git-2.43-red) | 2.43             |  
| ![Docker](https://img.shields.io/badge/Docker-20.10-blue) | Latest           |  
| ![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.27-blueviolet) | Latest           |  
| ![Ansible](https://img.shields.io/badge/Ansible-automation-red) | Latest           |  
| ![Jenkins](https://img.shields.io/badge/Jenkins-CI/CD-yellowgreen) | Latest           |  

---

## Installation on Redhat (Latest Version)

Install Git
yum install git -y

Install Java 21
yum install java-21* -y

Download and install Maven 3.9.9
wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz

Extract and set up Maven environment variables as needed
---

## Project Structure
<pre> 
.
├── Project
│ ├── Ansible # Ansible playbooks and Jenkinsfile for automation
│ ├── Docker-Kubernetes # Dockerfile, Kubernetes manifests, and Jenkinsfile
│ ├── Tomcat # Jenkinsfile for Tomcat deployments
├── pom.xml # Maven build descriptor
├── README.md # Project README (this file)
├── sonar-project.properties # SonarQube config for code quality
└── src # Source code with frontend and backend
</pre>


---

## How to Build and Run

1. Clone the repository:
git clone <repo-url>
cd project-ecommerce-java

2. Build the project using Maven:
mvn clean install

3. Run Tomcat server and deploy the built WAR file or use Docker/Kubernetes manifests to deploy containers.

4. Use Jenkins pipelines in respective folders for CI/CD automation.

---

## CI/CD Pipelines

- Jenkinsfiles are present under:
- `Project/Ansible/`
- `Project/Docker-Kubernetes/`
- `Project/Tomcat/`

These handle the stages like build, test, container image creation, deployment, and integration to JFrog Artifactory.

---

## Additional Notes

- JFrog Artifactory is configured for artifact storage; credentials should be managed securely.
- Kubernetes manifests help scale and manage containers in your environment.
- Ansible playbooks automate provisioning and deployments.

---
