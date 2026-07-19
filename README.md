# 🚨 RedFlag – The Fraud Files | SQL Fraud Detection Engine

A SQL-based fraud detection project that identifies suspicious financial transactions using real-world fraud detection techniques.

## 📌 Project Overview

**RedFlag – The Fraud Files** is a hands-on SQL project that analyzes over **200,000 simulated financial transactions** from an Indian payment aggregator. The objective is to detect multiple fraud patterns using only SQL queries—without Python, Machine Learning, or external tools.

This project demonstrates how SQL can be used to solve real-world fraud detection problems in the fintech industry.

## 🎯 Objectives

- Detect suspicious user activities
- Identify fraudulent transaction patterns
- Analyze merchant behavior
- Detect money laundering attempts
- Monitor refund abuse
- Generate actionable fraud insights


## 🛠️ Tech Stack

- MySQL
- SQL
- MySQL Workbench



## 📂 Dataset

- Simulated Indian payment transaction dataset
- Approximately **200,000 transactions**
- Multiple users, merchants, payment modes, cities, and transaction types



## 🔍 Fraud Patterns Implemented

### 1. Velocity Fraud
Detect users performing **30+ transactions in a single day**.

### 2. Round Amount Clustering
Identify suspicious transactions with repeated round amounts.

### 3. Card Testing Attack
Detect multiple failed low-value payment attempts.

### 4. Failed Payment Bursts
Find users with excessive failed transactions.

### 5. Late Night Transactions
Monitor transactions occurring between **1 AM and 5 AM**.

### 6. Money Mule Detection
Identify users receiving large credits and quickly spending them.

### 7. Refund Abuse
Detect excessive refund requests.

### 8. Merchant Collusion
Identify merchants with very few customers but unusually high revenue.

### 9. Structuring Transactions
Detect repeated transactions just below the reporting threshold (₹9,999).

### 10. Dormant Account Reactivation
Find accounts showing sudden activity after inactivity.

### 11. Transaction Spikes
Detect unusual increases in daily transaction volume.

### 12. Impossible Travel
Identify users making transactions from different cities within a short time period.


## 💡 SQL Concepts Used

- SELECT
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- Aggregate Functions
- CASE WHEN
- Self JOIN
- Correlated Subqueries
- Date & Time Functions
- TIMESTAMPDIFF()
- Window Functions


## 📁 Repository Structure

RedFlag-SQL-Fraud-Detection/
│
├── RedFlag_Himabindu.sql
├── Dataset/
├── README.md
└── Screenshots/


## 🚀 Learning Outcomes

- Writing advanced SQL queries
- Fraud detection using SQL
- Transaction analysis
- Data aggregation and filtering
- Analytical thinking
- Financial data analysis


## 📸 Sample Output

- Velocity Fraud Detection
- Money Mule Detection
- Impossible Travel Detection
- Merchant Risk Analysis



## 🎯 Future Improvements

- Interactive Power BI Dashboard
- Python Automation
- Machine Learning-Based Fraud Prediction
- Real-Time Fraud Alerts



## 👩‍💻 Author

**Tambi Himabindu**

- 💼 Aspiring Data Analyst
- 📊 SQL | Python | Power BI | Data Analytics



⭐ If you found this project useful, don't forget to star this repository!
