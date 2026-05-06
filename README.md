# 🛒 TechGear Shop - Production-Grade Deployment Project

[![Node.js Version](https://img.shields.io/badge/node-%3E%3D%2018.0.0-brightgreen)](https://nodejs.org/)
[![Framework](https://img.shields.io/badge/framework-Express.js-blue)](https://expressjs.com/)
[![Database](https://img.shields.io/badge/database-MongoDB-green)](https://www.mongodb.com/)
[![Infrastructure](https://img.shields.io/badge/infrastructure-AWS%20EC2-orange)](https://aws.amazon.com/)
[![Orchestration](https://img.shields.io/badge/orchestration-Docker%20Swarm-blue)](https://docs.docker.com/engine/swarm/)
[![Security](https://img.shields.io/badge/security-Trivy%20Scan-red)](https://aquasecurity.github.io/trivy/)

> **Final Project:** Software Deployment, Operations & Maintenance (Course: 502094)
> **Instructor:** MSc. Mai Van Manh
> **Developed by:** 
> - Doan Thanh Trong (523H0108)
> - Le Minh Kha (523H0036)

---

## 🌟 Project Overview
**TechGear Shop** is a high-performance product management application built with a **Model-View-Controller (MVC)** architecture. This project serves as a comprehensive demonstration of professional deployment strategies, including automated cloud infrastructure, container orchestration, DevSecOps pipelines, and real-time system monitoring.

### 🛡️ Core Technical Features
*   **Intelligent High Availability:** Features a smart fallback mechanism. If the MongoDB connection fails (3s timeout), the system automatically transitions to an `in-memory datastore` to ensure zero service disruption.
*   **Production-Ready CRUD API:** A robust RESTful API for full product lifecycle management.
*   **Server-Side Rendering (SSR):** Optimized UI built with `EJS` and `Bootstrap 5` for an intuitive administrative experience.
*   **Automated Media Management:** Built-in support for image uploads with automated physical file cleanup upon product deletion or updates.
*   **Smart Database Seeding:** Automatically seeds the database with a curated list of Apple products upon the first successful connection to a fresh MongoDB instance.

---

## 🏗️ System Architecture

**1. Client Access:** 
Users access the application securely via HTTPS. All incoming traffic is intercepted and routed by the **Nginx Proxy Manager**.

**2. Application & Data Layer (AWS Production):**
*   **Load Balancing:** The Nginx proxy distributes requests across multiple **Express.js Replicas** operating within the Docker Swarm cluster.
*   **Database:** The core application queries a **MongoDB** database for persistent product data.
*   **Fault Tolerance:** An **In-Memory Store** serves as an automatic fallback mechanism to keep the system operational if the database connection drops.
*   **Media Persistence:** Uploaded files and media are persisted to an **AWS S3 Bucket** (or persistent attached volumes).

**3. Observability Stack:**
*   **Metrics Collection:** Application and node-level metrics are continuously scraped and aggregated by **Prometheus**.
*   **Visualization:** **Grafana** connects to Prometheus to provide a real-time, visual dashboard for system health and performance monitoring.

---

## 🛠️ Technology Stack
| Layer | Technologies |
| :--- | :--- |
| **Backend** | Node.js (Express), Mongoose, Multer |
| **Frontend** | EJS Templates, Bootstrap 5 |
| **Database** | MongoDB (NoSQL) & In-memory Fallback |
| **Infrastructure** | AWS (EC2, S3, Security Groups), Terraform, Ansible |
| **Containerization** | Docker, Docker Swarm (Multi-node Tier 4) |
| **DevSecOps** | GitHub Actions, Trivy Vulnerability Scan, Docker Hub |
| **Monitoring** | Prometheus, Grafana, Node Exporter |

---

## 🚀 Getting Started

### 1. Prerequisites
*   Node.js 18.x or higher
*   Docker Engine & Docker Compose (for local containerized testing)
*   AWS Account (for cloud deployment)

### 2. Environment Configuration
Create a `.env` file in the root directory:
```env
PORT=3000
MONGO_URI=mongodb://<your_db_host>:27017/techgear_db
NODE_ENV=production
```

### 3. Installation & Local Execution
```bash
# Install dependencies
npm install

# Start in Production mode
npm start

# Start in Development mode (with nodemon)
npm run dev
```
Access the application at: `http://localhost:3000`

---

## 🔌 API Documentation

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/products` | Retrieve all products (JSON) |
| `GET` | `/products/:id` | Get specific product details |
| `POST` | `/products` | Create product (Supports Multipart/Form-data) |
| `PUT` | `/products/:id` | Full product replacement |
| `PATCH` | `/products/:id` | Partial product update |
| `DELETE` | `/products/:id` | Delete product and associated image |

**Sample cURL Request:**
```bash
curl -X POST -F "name=MacBook M3" -F "price=1299" -F "imageFile=@laptop.jpg" http://localhost:3000/products
```

---

## 📈 Monitoring & Reliability
The system implements a full **Prometheus & Grafana** stack to ensure operational excellence:
*   **Real-time Observability:** Monitoring CPU, Memory, Network Traffic, and Disk I/O across the Swarm cluster.
*   **Self-Healing:** Docker Swarm automatically restarts containers in the event of application failure.
*   **Security Fail Gates:** The CI/CD pipeline automatically blocks deployments if **Critical** or **High** vulnerabilities are detected by the Trivy security scanner.

---

## 📄 License
This project is developed for educational purposes at **Ton Duc Thang University (TDTU)**.

---
© 2026 - Team TechGear (Trong & Kha)