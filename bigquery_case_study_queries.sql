
-- BigQuery Table Creation Scripts

CREATE TABLE `your_project.your_dataset.customers` (
  customer_id STRING,
  age INT64,
  region STRING,
  account_type STRING,
  monthly_balance FLOAT64,
  credit_score INT64,
  is_churned BOOL
);

CREATE TABLE `your_project.your_dataset.transactions` (
  transaction_id STRING,
  customer_id STRING,
  transaction_date DATE,
  amount FLOAT64,
  merchant_category STRING,
  is_fraudulent BOOL
);

CREATE TABLE `your_project.your_dataset.support_logs` (
  log_id STRING,
  customer_id STRING,
  support_date DATE,
  issue_type STRING,
  resolved BOOL,
  complaint_flag BOOL
);

-- Sample SQL Queries

-- Churn Prediction Features (Join & Explore)
SELECT 
  c.customer_id,
  c.age,
  c.credit_score,
  c.monthly_balance,
  COUNT(t.transaction_id) AS transaction_count,
  AVG(t.amount) AS avg_transaction_amount,
  COUNT(DISTINCT s.log_id) AS support_issues,
  c.is_churned
FROM `your_project.your_dataset.customers` c
LEFT JOIN `your_project.your_dataset.transactions` t
  ON c.customer_id = t.customer_id
LEFT JOIN `your_project.your_dataset.support_logs` s
  ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.age, c.credit_score, c.monthly_balance, c.is_churned;

-- Fraud Analysis (High-Value Fraud)
SELECT 
  transaction_id,
  customer_id,
  amount,
  merchant_category,
  transaction_date
FROM `your_project.your_dataset.transactions`
WHERE is_fraudulent = TRUE
ORDER BY amount DESC
LIMIT 20;

-- Customer Complaint Hotspots
SELECT 
  issue_type,
  COUNT(*) AS complaint_count
FROM `your_project.your_dataset.support_logs`
WHERE complaint_flag = TRUE
GROUP BY issue_type
ORDER BY complaint_count DESC;
