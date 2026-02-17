# 📊 Customer Lifetime Value & Revenue Sustainability Analysis  
## 🛒 Olist Marketplace | SQL Project

---

# 📌 Project Overview

This project evaluates customer lifetime value (CLV) and long-term revenue sustainability within the Olist marketplace.

The core question was:

Is Olist’s revenue model driven by customer retention, or does it depend mainly on continuous acquisition of new customers?

Rather than stopping at descriptive metrics, this analysis connects customer behavior to revenue structure, operational performance, and strategic implications.

---
## 🚀 Strategic Impact

This project goes beyond metric reporting and evaluates structural revenue sustainability. The analysis identifies that Olist operates as an acquisition-driven marketplace and quantifies the financial implications of weak retention. It further demonstrates how targeted acquisition toward high-repeat product categories can materially improve customer lifetime value and marketing efficiency.


# 🎯 Business Context

E-commerce businesses typically grow through:

- Retention-driven compounding revenue  
- Continuous acquisition of new customers  

Retention-driven businesses build stability over time.  
Acquisition-driven businesses rely heavily on marketing spend.

This project determines where Olist stands — and what that means for revenue sustainability.

---

# 🗂 Data & Technical Approach

## 📁 Tables Used

- orders  
- order_payments  
- customers  
- order_items  
- products  

## 🛠 Techniques Applied

- Common Table Expressions (CTEs)  
- Window Functions (ROW_NUMBER, NTILE)  
- Cohort Analysis  
- Revenue decomposition  
- Customer-level aggregation  
- Behavioral segmentation  
- Scenario-based revenue simulation  

All analysis was conducted in MySQL.

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

Repeat customers generate nearly 2x revenue per customer, but they represent a very small portion of the base.

---

## 🔎 Key Insight

Revenue does not compound through repeat behavior.

Instead, revenue depends heavily on first-time purchases.

Olist operates as a structurally acquisition-driven marketplace.

---

# 📈 Cohort Retention Analysis

Customers were grouped by first purchase month to measure retention over time.

## Findings

- Month 1 retention ≈ near zero  
- No stable retention curve  
- Average customer lifespan ≈ 2.7 days  
- Purchase frequency ≈ 1.03  

Customers typically purchase once and do not return.

This confirms structural retention weakness.

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

## Interpretation

Delivery reliability influences retention.

However, because most deliveries are already on-time, delivery performance alone cannot explain the overall retention weakness.

It is a contributing factor — not the main structural driver.

---

# 💳 First-Order Value Segmentation

Customers were divided into quartiles using NTILE(4) based on first-order value.

## Return Rates by Spend Level

- Lowest Quartile → 3.35%  
- Highest Quartile → 2.93%  

There was no meaningful variation across spending levels.

## Interpretation

Higher initial spending does not increase repeat probability.

Retention weakness is not driven by basket size or initial customer value.

---

# 🛍 Product Category Retention Analysis

To ensure statistical reliability, only categories with 500 or more first-time customers were analyzed.

## Observations

- Most categories → 1–3% repeat rate  
- Console Games → 1.73%  
- Eletrodomesticos → 9.14%  

## Interpretation

Some product categories naturally support stronger repeat behavior.

Retention differences are influenced more by product structure than by spend level.

---

# 📉 Revenue Impact Simulation

We modeled a conservative scenario:

If 5% of one-time buyers (approximately 4,655 customers) converted into repeat customers behaving like existing repeat buyers:

- Additional Revenue ≈ 698,250  
- Estimated uplift ≈ 4–5% of total revenue  

## Insight

Even small improvements in retention could meaningfully improve revenue stability.

---

# 🎯 Acquisition Mix Analysis

Because categories show different repeat rates:

Acquiring 1,000 customers in:

- A 2% repeat category → ~20 repeat customers  
- A 9% repeat category → ~90 repeat customers  

This creates more than 4x difference in expected repeat revenue from the same marketing spend.

## Marketing Efficiency Implication

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
- Avoid blanket retention campaigns across low-repeat verticals  

---

# 🏁 Final Conclusion

The analysis reveals:

- Olist is structurally acquisition-driven  
- 97% of customers purchase only once  
- Retention remains extremely weak across most segments  
- Delivery performance slightly influences repeat behavior  
- Spend level does not drive retention  
- Certain product categories demonstrate stronger repeat dynamics  

Revenue sustainability depends not only on operational improvements, but on smarter acquisition targeting and vertical-level strategy.

## 🔒 Overall Assessment

Olist’s current growth model is sustainable only as long as acquisition remains strong. Without improvements in retention or more targeted acquisition strategies, long-term revenue stability remains vulnerable to changes in marketing efficiency and customer acquisition costs.

This project provides a data-backed foundation for optimizing acquisition mix, protecting customer experience, and identifying verticals with higher lifetime value potential.

---

# 💡 What This Project Demonstrates

- Advanced SQL proficiency (CTEs, window functions, cohort modeling)  
- Revenue decomposition and customer-level analysis  
- Behavioral segmentation  
- Scenario-based financial modeling  
- Ability to connect technical analysis to strategic business decisions  
- Structured, executive-level analytical thinking  
