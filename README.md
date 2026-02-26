# 📊 Customer Lifetime Value & Revenue Sustainability Analysis  
🛒 Olist Marketplace | SQL Project  

---

## 📌 Project Overview

This project evaluates customer lifetime value (CLV) and long-term revenue sustainability within the Olist marketplace.

**Core Question:**  
Is Olist’s revenue model driven by customer retention, or does it depend mainly on continuous acquisition of new customers?

Rather than stopping at descriptive metrics, this analysis connects customer behavior to revenue structure, operational performance, and strategic implications.

---

## 🚀 Strategic Impact

This project evaluates whether Olist’s growth model is structurally stable or dependent on constant acquisition.  
The analysis quantifies how weak retention impacts revenue sustainability and how targeted acquisition can improve long-term value.

---

## 🎯 Business Context

E-commerce businesses typically grow through:

- Retention-driven compounding revenue  
- Continuous acquisition of new customers  

Retention-driven businesses build revenue stability over time.  
Acquisition-driven businesses depend heavily on ongoing marketing efficiency.

This project determines where Olist stands — and what that means for revenue sustainability.

---

## 🗂 Data & Technical Approach

### 📁 Tables Used
- orders  
- order_payments  
- customers  
- order_items  
- products  

### 🛠 Techniques Applied
- Common Table Expressions (CTEs)  
- Window Functions (ROW_NUMBER, NTILE)  
- Cohort Analysis  
- Revenue decomposition  
- Customer-level aggregation  
- Behavioral segmentation  
- Scenario-based revenue simulation  

All analysis was conducted in MySQL.

---

## 🧹 Data Cleaning & Assumptions

This project focuses on customer behavior and revenue modeling.  
The Olist dataset is already structured and relational, so heavy preprocessing was not required.

However, several controls were applied to ensure analytical accuracy.

### ✅ What Was Done

Revenue was calculated using: `SUM(payment_value) GROUP BY order_id`  
→ Prevents duplication from installment payments.

Repeat customers were identified using `customer_unique_id`  
→ Ensures accurate tracking across multiple orders.

First orders were identified using `ROW_NUMBER()`  
→ Guarantees correct lifecycle modeling.

For delivery impact analysis:

Orders without delivery timestamps were treated as late.  
This prevents incomplete deliveries from being incorrectly classified as on-time.

---

### ⚠️ Scope Decisions

A separate cleaned table (e.g., `clean_delivered_orders`) was not created.  
Orders were not explicitly filtered to `order_status = 'delivered'`.

**Reason:**  
Revenue was calculated using payment records, which represent completed financial transactions.  
Filtering delivered-only orders would not materially change revenue totals or retention trends.

If filtered to delivered-only orders, overall directional results would remain consistent.

---

### 🏭 Production-Level Enhancements (If This Were a Live System)

In a production environment, the following enhancements would improve robustness:

- Explicit filtering to delivered orders only  
- Automated validation checks  
- Outlier monitoring for extreme payment values  

These improvements strengthen reliability but would not materially change strategic conclusions.

---

## 🎯 Conclusion on Data Quality

The dataset required minimal structural cleaning for behavioral and revenue modeling.  
All key calculations were controlled for duplication and customer identity, ensuring directionally reliable results.

---

# 💰 Revenue Structure Breakdown

## 👥 Customer Distribution

- Total Unique Customers: 96,095  
- One-Time Buyers: 93,098 (≈97%)  
- Repeat Buyers: 2,997 (≈3%)

## 💵 Revenue Split

- One-Time Revenue: 15,064,849 (94.1%)  
- Repeat Revenue: 944,022 (5.9%)  
- Total Revenue: 16,008,872  

## 📈 Revenue Per Customer

- One-Time Avg Revenue ≈ 161  
- Repeat Avg Revenue ≈ 315  

Repeat customers generate nearly 2x revenue per customer but represent only 3% of the customer base.

---

## 🔎 Key Insight

Revenue does not compound through repeat behavior.  
Olist’s revenue model is structurally acquisition-driven rather than retention-driven.

---

# 📈 Cohort Retention Analysis

Customers were grouped by first purchase month to measure retention over time.

### Findings

- Month 1 retention ≈ near zero  
- No stable retention curve  
- Average customer lifespan ≈ 2.7 days  
- Purchase frequency ≈ 1.03  

Customers typically purchase once and do not return.  
This confirms systemic retention weakness rather than temporary churn fluctuation.

---

# 🚚 Delivery Performance & Retention

We tested whether first delivery experience impacts repeat behavior.

## 📦 Delivery Distribution

- On-Time Deliveries: 88,504  
- Late Deliveries: 7,592  

Most deliveries were already on-time.

## 🔁 Return Rates

- On-Time First Orders → 3.17%  
- Late First Orders → 2.56%  

Late delivery reduces repeat probability by approximately 19% (relative difference).

**Interpretation:**  
Delivery reliability influences repeat probability.  
However, since most deliveries are already on-time, delivery performance alone does not explain overall retention weakness.

---

# 💳 First-Order Value Segmentation

Customers were divided into quartiles using `NTILE(4)` based on first-order value.

### Return Rates by Spend Level

- Lowest Quartile → 3.35%  
- Highest Quartile → 2.93%  

There is no meaningful variation in repeat probability across spending levels.  
Retention weakness is structural and not driven by initial basket size.

---

# 🛍 Product Category Retention Analysis

To ensure statistical reliability, only categories with 500 or more first-time customers were analyzed.

### Observations

- Most categories → 1–3% repeat rate  
- Console Games → 1.73%  
- Eletrodomesticos → 9.14%  

Retention varies significantly by product category.  
Product structure has a stronger influence on repeat behavior than initial spend level.

---

# 📉 Revenue Impact Simulation

We modeled a conservative scenario:

If 5% of one-time buyers (approximately 4,655 customers) converted into repeat customers behaving like existing repeat buyers:

- Additional Revenue ≈ 698,250  
- Estimated uplift ≈ 4–5% of total revenue  

Even modest improvements in retention could meaningfully improve revenue stability.  
Small behavioral shifts can generate material financial impact.

---

# 🎯 Acquisition Mix Analysis

Because categories show different repeat rates:

Acquiring 1,000 customers in:

- A 2% repeat category → ~20 repeat customers  
- A 9% repeat category → ~90 repeat customers  

This creates more than a 4x difference in expected repeat revenue from the same marketing spend.

### Marketing Efficiency Implication

Untargeted acquisition:
- Attracts mostly low-repeat customers  
- Keeps CLV low  
- Increases dependency on marketing  

Targeted acquisition toward higher-retention categories:
- Improves repeat probability  
- Increases CLV  
- Enhances marketing ROI  
- Strengthens long-term revenue stability  

---

# 🧠 Business Recommendations

- Shift toward targeted acquisition strategies focused on high-repeat categories  
- Protect first-order experience to avoid suppressing repeat probability  
- Apply vertical-specific retention strategies in naturally repeat-friendly categories  
- Avoid blanket retention campaigns across structurally low-repeat verticals  

---

# 🏁 Final Conclusion

The analysis reveals:

- Olist is structurally acquisition-driven  
- 97% of customers purchase only once  
- Retention remains extremely weak across most segments  
- Delivery performance slightly influences repeat behavior  
- Spend level does not drive retention  
- Certain product categories demonstrate stronger repeat dynamics  

Revenue sustainability depends not only on operational improvements but on smarter acquisition targeting and category-level strategy.

---

# 🔒 Overall Assessment

Olist’s growth model remains sustainable only as long as acquisition performance remains strong.  
Without retention improvement or acquisition mix optimization, long-term revenue stability is vulnerable to marketing efficiency changes.

---

# 💡 What This Project Demonstrates

- Advanced SQL proficiency (CTEs, window functions, cohort modeling)  
- Revenue decomposition and customer-level analysis  
- Behavioral segmentation  
- Scenario-based financial modeling  
- Ability to connect technical analysis to strategic business decisions  
- Structured, executive-level analytical thinking  
