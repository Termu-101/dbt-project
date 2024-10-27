# Answer for Exercise 4

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order
    FROM {{ ref('stg_sales') }}
    GROUP BY customer_id
),
customer_frequency AS (
    SELECT
        customer_id,
        total_orders,
        first_order,
        last_order,
        CASE 
            WHEN total_orders > 1 THEN 
                (DATE_PART('day', last_order - first_order) / NULLIF(total_orders - 1, 0))
            ELSE NULL
        END AS avg_days_between_orders
    FROM customer_orders
)
SELECT
    customer_id,
    total_orders,
    first_order,
    last_order,
    avg_days_between_orders
FROM customer_frequency
ORDER BY customer_id;

