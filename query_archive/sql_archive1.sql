SELECT orders.meal_id,
       sum(meal_price * orders.order_quantity) AS revenue
FROM meals
    INNER JOIN orders USING (meal_id)
GROUP BY orders.meal_id;

SELECT meals.eatery,
       sum(meal_price * order_quantity)
FROM meals
    INNER JOIN orders USING (meal_id)
GROUP BY eatery;

SELECT date_trunc('month', orders.order_date)::date AS MONTH,
       sum(meal_price * order_quantity)             AS revenue
FROM meals
    INNER JOIN orders USING (meal_id)
GROUP BY MONTH;

SELECT user_id,
       sum(order_quantity * meal_price) AS revenue
FROM orders
    INNER JOIN meals USING (meal_id)
GROUP BY user_id;

WITH revenue AS (
    SELECT date_trunc('month', order_date)::date AS delivr_month,
           sum(order_quantity * meal_price)      AS revenue
    FROM meals
        JOIN orders ON meals.meal_id = orders.meal_id
    GROUP BY delivr_month
),
-- Set up the cost CTE
COST AS (
    SELECT date_trunc('month', stocking_date)::date AS delivr_month,
           sum(stocked_quantity * meal_cost) AS
           COST
    FROM meals
        JOIN stock ON meals.meal_id = stock.meal_id
    GROUP BY delivr_month)
    -- Calculate profit by joining the CTEs
    SELECT revenue.delivr_month,
           revenue -
           COST AS profit
    FROM revenue
        JOIN
        COST ON revenue.delivr_month = cost.delivr_month
    ORDER BY revenue.delivr_month ASC;

SELECT date_trunc('month', orders.order_date)::date  AS MONTH,
       sum(order_quantity *(meal_price - meal_cost)) AS profit
FROM orders
    INNER JOIN meals USING (meal_id)
GROUP BY MONTH
ORDER BY MONTH;

SELECT DISTINCT user_id,
                sum(order_quantity * meal_price) OVER (PARTITION BY user_id)              AS revenue,
                sum(order_quantity *(meal_price - meal_cost)) OVER (PARTITION BY user_id) AS profit
FROM orders
    INNER JOIN meals USING (meal_id);

SELECT user_id,
       sum(order_quantity * meal_price) AS money,
       'revenue'                        AS type
FROM orders
    INNER JOIN meals USING (meal_id)
GROUP BY user_id
UNION ALL
SELECT user_id,
       sum(order_quantity *(meal_price - meal_cost)) AS money,
       'profit'                                      AS type
FROM orders
    INNER JOIN meals USING (meal_id)
GROUP BY user_id;

SELECT DISTINCT date_trunc('week', order_date)::date                                                                   AS week,
                sum(order_quantity * meal_price) OVER (PARTITION BY date_trunc('week', order_date)::date)              AS revenue,
                sum(order_quantity *(meal_price - meal_cost)) OVER (PARTITION BY date_trunc('week', order_date)::date) AS profit
FROM orders
    INNER JOIN meals USING (meal_id);

WITH regs AS (
    SELECT user_id,
           min(order_date) AS reg_date
    FROM orders
    GROUP BY user_id
)
SELECT date_trunc('month', reg_date)::date AS delivr_month,
       count(user_id)                      AS registrations,
       avg(count(user_id)) OVER ()         AS avg_reg
FROM regs
GROUP BY delivr_month
ORDER BY delivr_month;

SELECT date_trunc('month', order_date)::date AS delivr_month,
       count(DISTINCT user_id)               AS mau
FROM orders
GROUP BY delivr_month
ORDER BY delivr_month;

SELECT date_trunc('day', order_date)::date AS delivr_day,
       count(DISTINCT user_id)             AS dau
FROM orders
GROUP BY delivr_day
ORDER BY delivr_day;

WITH avg_monthly_dau AS (
    SELECT date_trunc('month', delivr_day)::date AS delivr_month,
           avg(dau)                              AS avg_monthly_dau
    FROM (
        SELECT date_trunc('day', order_date)::date AS delivr_day,
               count(DISTINCT user_id)             AS dau
        FROM orders
        GROUP BY delivr_day)
    GROUP BY delivr_month
),
mau AS (
    SELECT date_trunc('month', order_date)::date AS delivr_month,
           count(DISTINCT user_id)               AS mau
    FROM orders
    GROUP BY delivr_month
)
SELECT delivr_month,
       round((avg_monthly_dau / mau) * 100, 2) AS stickiness_pct
FROM avg_monthly_dau
    INNER JOIN mau USING (delivr_month)
ORDER BY delivr_month;

SELECT *
FROM table_columns;

WITH avg_monthly_dau AS (
    SELECT eatery,
           date_trunc('month', delivr_day)::date AS delivr_month,
           avg(dau)                              AS avg_monthly_dau
    FROM (
        SELECT eatery,
               date_trunc('day', order_date)::date AS delivr_day,
               count(DISTINCT user_id)             AS dau
        FROM orders
            INNER JOIN meals USING (meal_id)
        GROUP BY delivr_day, eatery)
    GROUP BY delivr_month, eatery
),
mau AS (
    SELECT eatery,
           date_trunc('month', order_date)::date AS delivr_month,
           count(DISTINCT user_id)               AS mau
    FROM orders
        INNER JOIN meals USING (meal_id)
    GROUP BY delivr_month, eatery
)
SELECT mau.eatery,
       mau.delivr_month,
       round((avg_monthly_dau / mau) * 100, 2) AS stickiness_pct
FROM avg_monthly_dau AS amdau
    INNER JOIN mau ON mau.delivr_month = amdau.delivr_month
        AND mau.eatery = amdau.eatery
    ORDER BY delivr_month,
        eatery;

WITH registrations AS (
    SELECT user_id,
           min(order_date) AS reg_date
    FROM orders
    GROUP BY user_id
),
regs_permonth AS (
    SELECT date_trunc('month', reg_date)::date AS delivr_month,
           count(user_id)                      AS reg_count
    FROM registrations
    GROUP BY delivr_month
)
SELECT delivr_month,
       sum(reg_count) OVER (ORDER BY delivr_month ASC) AS regs_rt
FROM regs_permonth
ORDER BY delivr_month;

WITH date_range AS (
    SELECT generate_series(min(order_date), max(order_date), INTERVAL '1 day')::date AS date
    FROM orders
),
running_mau AS (
    SELECT d.date,
           count(DISTINCT o.user_id) AS mau_30d
    FROM date_range AS d
        INNER JOIN orders AS o ON o.order_date BETWEEN d.date - 29 AND d.date
    GROUP BY d.date
)
SELECT date,
       mau_30d
FROM running_mau
WHERE date >=(
        SELECT min(order_date) + 29
        FROM orders)
ORDER BY date;

WITH date_range AS (
    SELECT generate_series(min(order_date), max(order_date), INTERVAL '1 day')::date AS date
    FROM orders
),
running_mau AS (
    SELECT m.eatery,
           d.date,
           count(DISTINCT o.user_id) AS mau_30d
    FROM date_range AS d
        INNER JOIN orders AS o ON o.order_date BETWEEN d.date - 29 AND d.date
        INNER JOIN meals AS m ON m.meal_id = o.meal_id
    GROUP BY d.date,
        m.eatery
)
SELECT eatery,
       date,
       mau_30d
FROM running_mau
WHERE date >=(
        SELECT min(order_date) + 29
        FROM orders)
ORDER BY date;

WITH mau AS (
    SELECT date_trunc('month', order_date)::date AS delivr_month,
           count(DISTINCT user_id)               AS mau
    FROM orders
    GROUP BY delivr_month
),
mau_lag AS (
    SELECT delivr_month,
           mau,
           lag(mau) OVER (ORDER BY delivr_month) AS last_mau
    FROM mau
)
SELECT delivr_month,
       mau,
       last_mau,
       mau - last_mau AS mau_delta
FROM mau_lag;

WITH mau AS (
    SELECT date_trunc('month', order_date)::date AS delivr_month,
           count(DISTINCT user_id)               AS mau
    FROM orders
    GROUP BY delivr_month
),
mau_lag AS (
    SELECT delivr_month,
           mau,
           lag(mau) OVER (ORDER BY delivr_month) AS last_mau
    FROM mau
)
SELECT delivr_month,
       round((((mau - last_mau)::numeric / last_mau) * 100), 2) AS mau_growth_rate_pct
FROM mau_lag;

WITH wau AS (
    SELECT date_trunc('week', order_date)::date AS delivr_week,
           count(DISTINCT user_id)              AS wau
    FROM orders
    GROUP BY delivr_week
),
wau_lag AS (
    SELECT delivr_week,
           wau,
           lag(wau) OVER (ORDER BY delivr_week) AS last_wau
    FROM wau
)
SELECT delivr_week,
       wau - last_wau                                           AS wau_growth,
       round((((wau - last_wau)::numeric / last_wau) * 100), 2) AS wau_growth_rate_pct
FROM wau_lag;

WITH orders_permonth AS (
    SELECT eatery,
           date_trunc('month', order_date)::date AS delivr_month,
           count(DISTINCT order_id)              AS orders
    FROM orders
        INNER JOIN meals USING (meal_id)
    GROUP BY delivr_month, eatery
),
orders_lag AS (
    SELECT eatery,
           delivr_month,
           orders,
           lag(orders) OVER (PARTITION BY eatery ORDER BY delivr_month) AS lastmonth_orders
    FROM orders_permonth
)
SELECT eatery,
       delivr_month,
       orders,
       lastmonth_orders,
       round(((orders - lastmonth_orders)::numeric / nullif(lastmonth_orders, 0)) * 100, 2) AS MoM_order_growth_rate_pct
FROM orders_lag
ORDER BY delivr_month;

WITH user_activity AS (
    SELECT DISTINCT date_trunc('month', order_date)::date              AS delivr_month,
                    user_id,
                    max(date_trunc('month', order_date)::date) OVER () AS last_month
    FROM orders
)
SELECT previous.delivr_month,
       round((count(DISTINCT current.user_id)::numeric / nullif(count(DISTINCT previous.user_id), 0)) * 100, 2) AS retention_rate_pct
FROM user_activity AS previous
    LEFT JOIN user_activity AS current ON previous.user_id = current.user_id
        AND previous.delivr_month =(current.delivr_month - interval '1 month')
WHERE previous.delivr_month != previous.last_month
GROUP BY previous.delivr_month
ORDER BY previous.delivr_month;

WITH user_activity AS (
    SELECT DISTINCT date_trunc('week', order_date)::date              AS delivr_week,
                    eatery,
                    user_id,
                    max(date_trunc('week', order_date)::date) OVER () AS last_week
    FROM orders
        INNER JOIN meals USING (meal_id))
SELECT previous.delivr_week,
       previous.eatery,
       round((count(DISTINCT current.user_id)::numeric / nullif(count(DISTINCT previous.user_id), 0)) * 100, 2) AS retention_rate_pct
FROM user_activity AS previous
    LEFT JOIN user_activity AS current ON previous.user_id = current.user_id
        AND previous.eatery = current.eatery
        AND previous.delivr_week =(current.delivr_week - interval '1 week')
WHERE previous.delivr_week != previous.last_week
GROUP BY previous.delivr_week,
    previous.eatery
ORDER BY previous.delivr_week;

WITH users_first_order AS (
    SELECT min(order_date) AS first_order,
           user_id
    FROM orders
    GROUP BY user_id
),
regs_per_month AS (
    SELECT date_trunc('month', first_order)::date AS delivr_month,
           count(user_id)                         AS user_activity
    FROM users_first_order
    GROUP BY delivr_month
),
mau_cte AS (
    SELECT date_trunc('month', order_date)::date              AS delivr_month,
           min(date_trunc('month', order_date)::date) OVER () AS first_delivr_month,
           count(DISTINCT user_id)                            AS mau
    FROM orders
    GROUP BY delivr_month
),
user_activity AS (
    SELECT DISTINCT date_trunc('month', order_date)::date              AS delivr_month,
                    user_id,
                    max(date_trunc('month', order_date)::date) OVER () AS last_month
    FROM orders
),
retained_per_month AS (
    SELECT current.delivr_month,
           count(DISTINCT current.user_id) AS user_activity
    FROM user_activity AS previous
        LEFT JOIN user_activity AS current ON previous.user_id = current.user_id
            AND previous.delivr_month =(current.delivr_month - interval '1 month')
    GROUP BY current.delivr_month
    ORDER BY current.delivr_month
),
resurrected_per_month AS (
    SELECT delivr_month,
           mau -(retained_pm.user_activity + regs_pm.user_activity) AS user_activity
    FROM retained_per_month AS retained_pm
        INNER JOIN regs_per_month AS regs_pm USING (delivr_month)
        INNER JOIN mau_cte USING (delivr_month)
    WHERE delivr_month >= first_delivr_month + interval '2 months'
)
SELECT delivr_month,
       round(user_activity::numeric * 100 / nullif(mau, 0), 2) AS activity_pct,
       'new users'                                             AS type
FROM regs_per_month
    INNER JOIN mau_cte USING (delivr_month)
UNION
SELECT delivr_month,
       round(user_activity::numeric * 100 / nullif(mau, 0), 2) AS activity_pct,
       'retained users'                                        AS type
FROM retained_per_month
    INNER JOIN mau_cte USING (delivr_month)
UNION
SELECT delivr_month,
       round(user_activity::numeric * 100 / nullif(mau, 0), 2) AS activity_pct,
       'resurrected users'                                     AS type
FROM resurrected_per_month
    INNER JOIN mau_cte USING (delivr_month)
ORDER BY type,
    delivr_month;
