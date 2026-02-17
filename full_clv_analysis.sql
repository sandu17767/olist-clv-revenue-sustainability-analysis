/*
============================================================
PROJECT: Customer Lifetime Value & Revenue Sustainability
DATASET: Olist E-commerce
AUTHOR: Sanduni
DESCRIPTION:
Full structured SQL workflow covering:
- Revenue structure
- Cohort retention
- Delivery impact
- Spend segmentation
- Category retention
- Revenue uplift simulation
============================================================
*/

USE olist;

-- =========================================================
-- SECTION 1: REVENUE STRUCTURE & CUSTOMER DISTRIBUTION
-- =========================================================

WITH customer_orders AS (
    SELECT 
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN order_count = 1 THEN 1 ELSE 0 END) AS one_time_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers
FROM customer_orders;

-- =========================================================
-- SECTION 2: REVENUE SPLIT (ONE-TIME VS REPEAT)
-- =========================================================

WITH order_revenue AS (
    SELECT 
        order_id,
        SUM(payment_value) AS order_total_value
    FROM order_payments
    GROUP BY order_id
),

customer_orders AS (
    SELECT 
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),

customer_base AS (
    SELECT
        c.customer_unique_id,
        CASE 
            WHEN co.order_count = 1 THEN 'One-Time'
            ELSE 'Repeat'
        END AS customer_type,
        SUM(orv.order_total_value) AS total_revenue
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    JOIN order_revenue orv
        ON o.order_id = orv.order_id
    JOIN customer_orders co
        ON c.customer_unique_id = co.customer_unique_id
    GROUP BY c.customer_unique_id, customer_type
)
SELECT
    customer_type,
    COUNT(*) AS total_customers,
    SUM(total_revenue) AS group_revenue,
    ROUND(SUM(total_revenue) / COUNT(*), 2) AS avg_revenue_per_customer,
    ROUND(
        SUM(total_revenue) /
        SUM(SUM(total_revenue)) OVER () * 100,
        2
    ) AS revenue_share_percent
FROM customer_base
GROUP BY customer_type;

-- =========================================================
-- SECTION 3: COHORT RETENTION ANALYSIS
-- =========================================================

WITH first_purchase AS (
    SELECT 
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_purchase_date,
        DATE_FORMAT(MIN(o.order_purchase_timestamp), '%Y-%m') AS cohort_month
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),

cohort_data AS (
    SELECT 
        c.customer_unique_id,
        fp.cohort_month,
        TIMESTAMPDIFF(
            MONTH,
            fp.first_purchase_date,
            o.order_purchase_timestamp
        ) AS month_number
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    JOIN first_purchase fp
        ON c.customer_unique_id = fp.customer_unique_id
),

cohort_counts AS (
    SELECT
        cohort_month,
        month_number,
        COUNT(DISTINCT customer_unique_id) AS active_customers
    FROM cohort_data
    GROUP BY cohort_month, month_number
)

SELECT
    cohort_month,
    month_number,
    active_customers,
    MAX(CASE WHEN month_number = 0 THEN active_customers END)
        OVER (PARTITION BY cohort_month) AS cohort_size,
    ROUND(
        active_customers /
        MAX(CASE WHEN month_number = 0 THEN active_customers END)
            OVER (PARTITION BY cohort_month) * 100,
        2
    ) AS retention_rate_percent
FROM cohort_counts
ORDER BY cohort_month, month_number;

-- =========================================================
-- SECTION 4: DELIVERY PERFORMANCE IMPACT
-- =========================================================

WITH order_counts AS (
    SELECT 
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),

first_orders AS (
    SELECT 
        c.customer_unique_id,
        o.order_id,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS rn
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
),

first_delivery_status AS (
    SELECT
        customer_unique_id,
        CASE 
            WHEN order_delivered_customer_date > order_estimated_delivery_date 
            THEN 'Late'
            ELSE 'On-Time'
        END AS delivery_status
    FROM first_orders
    WHERE rn = 1
)

SELECT
    delivery_status,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN oc.order_count > 1 THEN 1 ELSE 0 END) AS returned_customers,
    ROUND(
        SUM(CASE WHEN oc.order_count > 1 THEN 1 ELSE 0 END) / COUNT(*) * 100,
        2
    ) AS return_rate_percent
FROM first_delivery_status fds
JOIN order_counts oc
    ON fds.customer_unique_id = oc.customer_unique_id
GROUP BY delivery_status;

-- =========================================================
-- SECTION 5: FIRST-ORDER VALUE SEGMENTATION
-- =========================================================

WITH order_revenue AS (
    SELECT 
        order_id,
        SUM(payment_value) AS order_total_value
    FROM order_payments
    GROUP BY order_id
),

first_orders AS (
    SELECT 
        c.customer_unique_id,
        o.order_id,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS rn
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
),

first_order_values AS (
    SELECT 
        fo.customer_unique_id,
        orv.order_total_value AS first_order_value
    FROM first_orders fo
    JOIN order_revenue orv
        ON fo.order_id = orv.order_id
    WHERE fo.rn = 1
),

value_quartiles AS (
    SELECT
        customer_unique_id,
        first_order_value,
        NTILE(4) OVER (ORDER BY first_order_value) AS value_quartile
    FROM first_order_values
),

order_counts AS (
    SELECT 
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)

SELECT
    value_quartile,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN oc.order_count > 1 THEN 1 ELSE 0 END) AS returned_customers,
    ROUND(
        SUM(CASE WHEN oc.order_count > 1 THEN 1 ELSE 0 END) / COUNT(*) * 100,
        2
    ) AS return_rate_percent
FROM value_quartiles vq
JOIN order_counts oc
    ON vq.customer_unique_id = oc.customer_unique_id
GROUP BY value_quartile
ORDER BY value_quartile;

-- =========================================================
-- SECTION 6: CATEGORY-LEVEL RETENTION
-- =========================================================

WITH order_counts AS (
    SELECT 
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),

first_orders AS (
    SELECT 
        c.customer_unique_id,
        o.order_id,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS rn
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
),

first_order_primary_category AS (
    SELECT
        fo.customer_unique_id,
        p.product_category_name,
        ROW_NUMBER() OVER (
            PARTITION BY fo.customer_unique_id
            ORDER BY oi.price DESC
        ) AS category_rank
    FROM first_orders fo
    JOIN order_items oi
        ON fo.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    WHERE fo.rn = 1
)

SELECT
    fopc.product_category_name,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN oc.order_count > 1 THEN 1 ELSE 0 END) AS returned_customers,
    ROUND(
        SUM(CASE WHEN oc.order_count > 1 THEN 1 ELSE 0 END) / COUNT(*) * 100,
        2
    ) AS return_rate_percent
FROM first_order_primary_category fopc
JOIN order_counts oc
    ON fopc.customer_unique_id = oc.customer_unique_id
WHERE fopc.category_rank = 1
GROUP BY fopc.product_category_name
HAVING COUNT(*) >= 500
ORDER BY return_rate_percent DESC;

-- =========================================================
-- SECTION 7: REVENUE UPLIFT SIMULATION
-- =========================================================

-- Based on observed metrics:
-- One-Time Customers ≈ 93,098
-- 5% Conversion ≈ 4,655 customers
-- Avg Repeat Revenue ≈ 314.99
-- Avg One-Time Revenue ≈ 161.82
-- Incremental Revenue per Converted Customer ≈ 153.17
-- Total Estimated Uplift ≈ 698,250
