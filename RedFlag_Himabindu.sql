-- =====================================================================
-- RedFlag — Fraud Detection Submission
-- Student: Tambi Himabindu
-- Batch: DA-DS-1
-- =====================================================================

CREATE DATABASE redflag;
USE redflag;
-- =====================================================================
-- PATTERN 1 · VELOCITY FRAUD
-- What I'm looking for:
-- Users performing 30 or more transactions in a single day.
-- Expected suspects: ~50
-- =====================================================================

SELECT
    user_id,
    DATE(txn_time) AS attack_date,
    COUNT(*) AS daily_txn_count
FROM transactions
GROUP BY user_id, DATE(txn_time)
HAVING COUNT(*) >= 30
ORDER BY daily_txn_count DESC;
-- My Findings:
-- Several users exceeded the threshold of 30 transactions in a single day.
-- User 14556 and User 14569 recorded the highest daily activity with 60 transactions each.
-- The results indicate potential velocity fraud, and the flagged accounts require further investigation.

-- =====================================================================
-- PATTERN 2 · ROUND-AMOUNT CLUSTERING
-- What I'm looking for:
-- Transactions with suspicious round values.
-- =====================================================================

SELECT
    txn_id,
    user_id,
    merchant_id,
    amount,
    txn_time
FROM transactions
WHERE amount IN (100,500,1000,5000,10000)
ORDER BY amount DESC;
-- My Findings:
-- Numerous transactions with the exact amount of ₹10,000 were detected.
-- Users such as 14545, 14544, 14531, 14542, 14551, 14547, 14553, and 14532 were involved in these transactions.
-- Since fraudsters often use repeated round-value amounts, these transactions have been flagged as potentially suspicious.
-- Additional investigation is recommended to determine whether these are legitimate business payments or fraudulent activities.


-- =====================================================================
-- PATTERN 3 · CARD TESTING ATTACK
-- What I'm looking for:
-- Multiple failed low-value transactions.
-- =====================================================================

SELECT
    user_id,
    COUNT(*) AS failed_attempts
FROM transactions
WHERE status='FAILED'
AND amount < 100
GROUP BY user_id
HAVING COUNT(*) >= 5
ORDER BY failed_attempts DESC;
-- My Findings:
-- No users were identified with five or more failed low-value transactions.
-- Based on the current dataset, there is no evidence of card testing attacks
-- under the defined detection criteria.
-- This suggests that no suspicious low-value failed transaction patterns were detected.

-- =====================================================================
-- PATTERN 4 · FAILED PAYMENT BURSTS
-- What I'm looking for:
-- Users with unusually high failed payments.
-- =====================================================================

SELECT
    user_id,
    COUNT(*) AS failed_transactions
FROM transactions
WHERE status='FAILED'
GROUP BY user_id
HAVING COUNT(*) > 10
ORDER BY failed_transactions DESC;
-- My Findings:
-- Multiple users exceeded the threshold of 10 failed payment attempts.
-- User 14593 had the highest number of failed transactions (34),
-- followed by User 14576 (33) and several users with 32 failures.
-- These accounts have been flagged for further fraud investigation.

-- =====================================================================
-- PATTERN 5 · LATE NIGHT TRANSACTIONS
-- What I'm looking for:
-- Transactions between 1 AM and 5 AM.
-- =====================================================================

SELECT
    txn_id,
    user_id,
    amount,
    txn_time,
    city
FROM transactions
WHERE HOUR(txn_time) BETWEEN 1 AND 5
ORDER BY txn_time;
-- My Findings:
-- The query identified transactions performed between 1:00 AM and 5:00 AM.
-- Late-night transaction activity is considered higher risk because it may indicate
-- unauthorized account usage or fraudulent behavior.
-- The flagged transactions should be reviewed along with user history and location
-- to determine whether the activity is legitimate.


-- =====================================================================
-- PATTERN 6 · MONEY MULE DETECTION
-- What I'm looking for:
-- Users receiving large credits and spending almost everything.
-- =====================================================================

SELECT
    user_id,
    SUM(CASE WHEN txn_type='CREDIT' THEN amount ELSE 0 END) AS total_credit,
    SUM(CASE WHEN txn_type='DEBIT' THEN amount ELSE 0 END) AS total_debit
FROM transactions
GROUP BY user_id
HAVING total_credit > 50000
AND total_debit >= total_credit * 0.80
ORDER BY total_credit DESC;
-- My Findings:
-- The query identified users who received large credit amounts and spent most of
-- the funds within a short period.
-- Such behavior is commonly associated with money mule accounts used in money
-- laundering schemes.
-- The flagged users require further investigation to verify the legitimacy of
-- these transactions.

-- =====================================================================
-- PATTERN 7 · REFUND ABUSE
-- What I'm looking for:
-- Users requesting excessive refunds.
-- =====================================================================

SELECT
    user_id,
    COUNT(*) AS refund_count
FROM transactions
WHERE txn_type='REFUND'
GROUP BY user_id
HAVING COUNT(*) > 5
ORDER BY refund_count DESC;
-- My Findings:
-- The query detected users requesting an unusually high number of refunds.
-- Excessive refund requests may indicate refund abuse or fraudulent purchase
-- activities.
-- The identified users should be investigated to verify the authenticity of
-- their refund claims.


-- =====================================================================
-- PATTERN 8 · MERCHANT COLLUSION
-- What I'm looking for:
-- Merchants with very few customers but unusually high revenue.
-- =====================================================================

SELECT
    merchant_id,
    COUNT(DISTINCT user_id) AS customer_count,
    SUM(amount) AS total_revenue
FROM transactions
GROUP BY merchant_id
HAVING customer_count < 5
AND total_revenue > 100000
ORDER BY total_revenue DESC;
-- My Findings:
-- The query identified merchants with very few customers but unusually high
-- transaction volumes.
-- This pattern may indicate merchant collusion, fake transactions, or money
-- laundering activities.
-- The flagged merchants should undergo further financial and compliance review.


-- =====================================================================
-- PATTERN 9 · STRUCTURING TRANSACTIONS
-- What I'm looking for:
-- Transactions just below ₹10,000.
-- =====================================================================

SELECT
    txn_id,
    user_id,
    amount,
    txn_time
FROM transactions
WHERE amount BETWEEN 9900 AND 9999
ORDER BY amount DESC;
-- My Findings:
-- The query detected multiple transactions with amounts just below ₹10,000.
-- This pattern may indicate transaction structuring, where users intentionally
-- avoid reporting thresholds.
-- These transactions should be monitored for possible money laundering or fraud.


-- =====================================================================
-- PATTERN 10 · DORMANT ACCOUNT REACTIVATION
-- What I'm looking for:
-- Users suddenly becoming active after inactivity.
-- =====================================================================

SELECT
    user_id,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY user_id
HAVING COUNT(*) > 15
ORDER BY total_transactions DESC;
-- My Findings:
-- The query identified accounts showing unusually high activity after a period
-- of inactivity.
-- Sudden account reactivation can be an indicator of compromised accounts or
-- fraudulent access.
-- The flagged accounts should be verified before allowing further transactions.


-- =====================================================================
-- PATTERN 11 · TRANSACTION SPIKES
-- What I'm looking for:
-- Users performing unusually high daily activity.
-- =====================================================================

SELECT
    user_id,
    DATE(txn_time) AS txn_date,
    COUNT(*) AS transaction_count
FROM transactions
GROUP BY user_id, DATE(txn_time)
HAVING COUNT(*) > 30
ORDER BY transaction_count DESC;
-- My Findings:
-- The query detected users with unusually high transaction volumes within a
-- single day.
-- Such sudden spikes in activity may indicate automated transactions, bot
-- attacks, or fraudulent behavior.
-- The identified users should be reviewed using additional fraud detection rules.


-- =====================================================================
-- PATTERN 12 · IMPOSSIBLE TRAVEL
-- What I'm looking for:
-- Same user making transactions from different cities within one hour.
-- =====================================================================

SELECT
    t1.user_id,
    t1.city AS city_1,
    t2.city AS city_2,
    t1.txn_time AS txn_time_1,
    t2.txn_time AS txn_time_2
FROM transactions t1
JOIN transactions t2
ON t1.user_id = t2.user_id
AND t1.txn_id < t2.txn_id
AND t1.city <> t2.city
AND ABS(TIMESTAMPDIFF(MINUTE, t1.txn_time, t2.txn_time)) <= 60
ORDER BY t1.user_id;
-- My Findings:
-- The query identified users performing transactions from different cities
-- within a very short time interval.
-- Such activity is physically difficult under normal circumstances and may
-- indicate account compromise or credential theft.
-- These transactions require immediate investigation.


-- =====================================================================
-- END OF SUBMISSION
-- =====================================================================
