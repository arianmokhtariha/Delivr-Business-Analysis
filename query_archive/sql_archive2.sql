WITH kpis AS (
    SELECT date_trunc('month', order_date)::date AS delivr_month,
           sum(meal_price * order_quantity)      AS revenue,
           count(DISTINCT user_id)               AS users
    FROM orders
        INNER JOIN meals USING (meal_id)
    GROUP BY delivr_month
)
SELECT delivr_month,
       round(revenue::numeric / nullif(users, 0), 2) AS arpu
FROM kpis
ORDER BY delivr_month;

WITH kpis AS (
    SELECT eatery,
           date_trunc('month', order_date)::date AS delivr_month,
           sum(meal_price * order_quantity)      AS revenue,
           count(DISTINCT user_id)               AS users
    FROM orders
        INNER JOIN meals USING (meal_id)
    GROUP BY delivr_month, eatery
)
SELECT delivr_month,
       eatery,
       round(revenue::numeric / nullif(users, 0), 2) AS arpu
FROM kpis
ORDER BY delivr_month;

WITH kpis AS (
    SELECT count(DISTINCT order_id)              AS orders,
           date_trunc('month', order_date)::date AS delivr_month,
           count(DISTINCT user_id)               AS users
    FROM orders
    GROUP BY delivr_month
)
SELECT delivr_month,
       round(orders::numeric / nullif(users, 0), 2) AS aop
FROM kpis
ORDER BY delivr_month;

WITH kpis AS (
    SELECT date_trunc('month', order_date)::date         AS delivr_month,
           count(DISTINCT user_id)                       AS users,
           sum(order_quantity *(meal_price - meal_cost)) AS profit
    FROM orders
        INNER JOIN meals USING (meal_id)
    GROUP BY delivr_month
)
SELECT delivr_month,
       round(profit::numeric / nullif(users, 0), 2) AS appu
FROM kpis
ORDER BY delivr_month;

WITH user_orders AS (
    SELECT user_id,
           count(DISTINCT order_id) AS orders
    FROM orders
    GROUP BY user_id
)
SELECT count(user_id) AS users,
       orders
FROM user_orders
GROUP BY orders
ORDER BY orders;

WITH user_profit AS (
    SELECT user_id,
           sum(order_quantity *(meal_price - meal_cost)) AS profit
    FROM orders
        INNER JOIN meals USING (meal_id)
    GROUP BY user_id
)
SELECT round(profit::numeric, -2) AS profit100,
       count(user_id)             AS users
FROM user_profit
GROUP BY profit100;

WITH user_profit AS (
    SELECT user_id,
           sum(order_quantity *(meal_price - meal_cost)) AS profit
    FROM orders
        INNER JOIN meals USING (meal_id)
    GROUP BY user_id
)
SELECT CASE WHEN profit < 60 THEN
        'low-profit users'
    WHEN profit < 200 THEN
        'medium-profit users'
    WHEN profit < 270 THEN
        'high-profit users'
    ELSE
        'extreme-profit users'
    END               AS profit_group,
       count(user_id) AS users
FROM user_profit
GROUP BY profit_group;

SELECT CASE WHEN meal_price < 4 THEN
        'Low-price meal'
    WHEN meal_price < 6 THEN
        'Mid-price meal'
    ELSE
        'High-price meal'
    END AS price_category,
       count(DISTINCT meal_id)
FROM meals
GROUP BY price_category;

WITH user_profit AS (
    SELECT user_id,
           sum(order_quantity *(meal_price - meal_cost)) AS profit
    FROM orders
        INNER JOIN meals USING (meal_id)
    GROUP BY user_id
)
SELECT round(percentile_cont(0.25) WITHIN GROUP (ORDER BY profit)::numeric, 2) AS profit_q1,
       round(percentile_cont(0.5) WITHIN GROUP (ORDER BY profit)::numeric, 2)  AS profit_q2,
       round(percentile_cont(0.75) WITHIN GROUP (ORDER BY profit)::numeric, 2) AS profit_q3,
       round(avg(profit)::numeric, 2)                                          AS profit_avg
FROM user_profit;

WITH user_profit AS (
    SELECT user_id,
           sum(order_quantity *(meal_price - meal_cost)) AS profit
    FROM orders
        INNER JOIN meals USING (meal_id)
    GROUP BY user_id
),
user_profit_percentiles AS (
    SELECT percentile_cont(0.10) WITHIN GROUP (ORDER BY profit) AS p10,
           percentile_cont(0.25) WITHIN GROUP (ORDER BY profit) AS p25,
           percentile_cont(0.75) WITHIN GROUP (ORDER BY profit) AS p75,
           percentile_cont(0.90) WITHIN GROUP (ORDER BY profit) AS p90
    FROM user_profit
)
SELECT CASE WHEN profit < p10 THEN
        'extreme-low-profit users'
    WHEN profit < p25 THEN
        'low-profit users'
    WHEN profit < p75 THEN
        'medium-profit users'
    WHEN profit < p90 THEN
        'high-profit users'
    ELSE
        'extreme-high-profit users'
    END               AS profit_group,
       count(user_id) AS users
FROM user_profit
    CROSS JOIN user_profit_percentiles
GROUP BY profit_group
ORDER BY users;

SELECT user_id,
       sum(order_quantity *(meal_price - meal_cost)) AS profit
FROM orders
    INNER JOIN meals USING (meal_id)
GROUP BY user_id;

SELECT meal_id,
       sum(order_quantity *(meal_price - meal_cost)) AS profit
FROM orders
    INNER JOIN meals USING (meal_id)
GROUP BY meal_id;

SELECT eatery,
       sum(order_quantity *(meal_price - meal_cost)) AS profit
FROM orders
    INNER JOIN meals USING (meal_id)
GROUP BY eatery;

SELECT order_id,
       sum(order_quantity *(meal_price - meal_cost)) AS profit
FROM orders
    INNER JOIN meals USING (meal_id)
GROUP BY order_id;