# 🚀 Tech Salary Transparency System

## 📌 Project Overview

This project is a **cloud-native microservices application** developed for the Cloud Computing Applications module.

The system allows users to:

* Submit salary information anonymously
* Search salaries by role, company, and experience
* Vote on salary submissions
* View salary statistics (average, median, etc.)

The system is designed using a **microservices architecture** and deployed using **Docker and Kubernetes**.

---

## 🏗️ Architecture Overview

The application follows a **Backend-for-Frontend (BFF) pattern** with multiple independent services.

### 🔁 High-Level Flow

User → Frontend → BFF → Microservices → PostgreSQL

---

## 🧩 Services

* **Frontend** – User interface
* **BFF (Backend-for-Frontend)** – API gateway and request orchestration
* **Identity Service** – User authentication and authorization
* **Salary Service** – Handles salary submissions
* **Vote Service** – Handles upvotes/downvotes
* **Search Service** – Salary filtering and retrieval
* **Stats Service** – Salary analytics

---

## 🗄️ Database Design

A single PostgreSQL instance is used with multiple schemas:

* `identity` → user data
* `salary` → salary submissions
* `community` → votes

This ensures **data privacy and separation**.

---

## ☁️ Technologies Used

* Frontend: (to be decided)
* Backend: Node.js / Java (to be decided)
* Database: PostgreSQL
* Containerization: Docker
* Orchestration: Kubernetes
* Cloud Platform: Azure

---

## 📁 Project Structure

```
tech-salary-system/
├── frontend/
├── bff/
├── services/
├── database/
├── k8s/
├── docker-compose.yml
└── README.md
```

---

## ⚙️ Setup Instructions (Initial)

> Detailed setup instructions will be added as development progresses.

### Clone the repository

```
git clone <repo-url>
cd tech-salary-system
```

---

## 👥 Team Responsibilities

Work is divided among team members based on services and responsibilities.

Each member is responsible for:

* Implementing their service
* Dockerizing the service
* Creating Kubernetes configurations

---

## 🔁 Development Workflow

* Feature branches for each service
* Pull requests for merging
* Regular integration testing using Docker

---

## 📌 Notes

* Frontend communicates only with BFF
* Internal services are not exposed publicly
* Salary submissions are anonymous
* Authentication is required only for voting

---

## 📅 Status

🚧 Project setup phase – Initial structure created

---

## 📄 License

This project is developed for academic purposes.
