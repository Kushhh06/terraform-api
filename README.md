# 🚀 Serverless Array Sorting API using AWS & Terraform

## 📌 Overview
This project implements a serverless REST API that processes and sorts arrays containing repeated two-digit numbers. The solution is built using AWS services and fully automated using Terraform, following Infrastructure as Code (IaC) principles.

The API validates input, performs sorting logic using AWS Lambda, and persists request-response logs in DynamoDB.

---

## 🏗️ Architecture
Client → API Gateway → AWS Lambda → DynamoDB

---

## ⚙️ Features
- Accepts HTTP POST requests with array input
- Validates repeated two-digit numbers (e.g., 11, 22, 33)
- Sorts the array in ascending order
- Stores input and output in DynamoDB
- Fully automated infrastructure using Terraform

---

## 🛠️ Tech Stack
- AWS Lambda – Backend logic (Python)
- API Gateway (HTTP API) – API endpoint
- DynamoDB – NoSQL database for logging
- Terraform – Infrastructure as Code
- Python 3.10 – Runtime environment

---

## 📂 Project Structure
terraform-api/
│── main.tf
│── outputs.tf
│── lambda/
│     └── lambda_function.py
│── README.md
│── .gitignore

---

## 🚀 Setup Instructions

### 1. Configure AWS Credentials
aws configure

### 2. Initialize Terraform
terraform init

### 3. Preview Infrastructure
terraform plan

### 4. Deploy Infrastructure
terraform apply

---

## 🧪 API Usage

### Endpoint
https://<api-id>.execute-api.ap-south-1.amazonaws.com/sort

### Request (POST)
{
  "array": [44, 11, 33, 22]
}

### Response
{
  "sorted_array": [11, 22, 33, 44]
}

---

## 🗄️ Data Storage
- DynamoDB Table: ArraySortLogsTF
- Stores request ID, input array, and sorted output

---

## 🧹 Cleanup
terraform destroy

---

## ⚠️ Notes
- Region used: ap-south-1 (Mumbai)
- Ensure AWS credentials are properly configured
- Terraform state files are excluded from version control

---

## 👨‍💻 Author
KUSHAL KUMAR.G
