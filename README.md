<div align="center">

# Delivr business analysis

A business report on seven months of orders from a food delivery startup: how it grows, why customers stay, and where the profit really comes from.

![Python](https://img.shields.io/badge/Python-3.13-3776AB?style=for-the-badge&logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-CTEs%20%26%20window%20functions-CC2927?style=for-the-badge)
![pandas](https://img.shields.io/badge/pandas-3.0-150458?style=for-the-badge&logo=pandas&logoColor=white)
![Plotly](https://img.shields.io/badge/Plotly-6.5-3F4F75?style=for-the-badge&logo=plotly&logoColor=white)
![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-2.0-D71F00?style=for-the-badge&logo=sqlalchemy&logoColor=white)
![Jupyter](https://img.shields.io/badge/Jupyter-Lab-F37626?style=for-the-badge&logo=jupyter&logoColor=white)

</div>

**Delivr** is a fictional food delivery startup. It works with five restaurants ("eateries"), sells their meals in its app, and keeps the difference between the meal price and what the eatery charges. The data covers **June to December 2018**: 1,304 customers and 11,351 orders. Every number below was calculated with SQL in PostgreSQL.

## Summary: what we found and what Delivr should do

| | What we found | What Delivr should do |
|---|---|---|
| [1](#1-growth) | More users join every month, but the growth rate fell from **84% to 34%** | Track the growth rate, not only the user count. Plan for slower growth |
| [2](#2-where-the-revenue-growth-came-from) | Revenue grew 17x. **76%** of the growth came from more users, **23%** from users ordering more often, **1%** from bigger orders | Order size is the unused lever: test meal bundles or a minimum order for free delivery |
| [3](#3-loyalty) | **72%** of December's users were returning customers. Every signup month was still **94%+** active in December | Protect this loyal base (for example with rewards) before spending more on new users |
| [4](#4-eateries) | Burgatorio brings the most revenue, but Bean Me Up Scotty keeps the most profit (**77%** vs **52%** margin) | Rank and promote eateries and meals by profit, not by revenue |
| [4](#4-eateries) | Life of Pie keeps **88%** of each sale, but its customers come back less and spend less | Add meals to its menu (only 2 sell) and promote it |
| [5](#5-customers) | **61%** of customers are needed to make 80% of the profit. No small group carries the business | Losing any single customer is low risk. Broad offers fit better than VIP programs |
| [6](#6-timing) | **Half** of all new users place their first order in the first 7 days of a month | Time campaigns and eatery capacity for the first week of each month |

<details>
<summary><b>Terms used in this report</b></summary>

| Term | Meaning |
|---|---|
| MAU (monthly active users) | People who ordered at least once in the month |
| DAU (daily active users) | People who ordered on that day |
| ARPU (average revenue per user) | Revenue in a period divided by the active users in that period |
| Average order value | Revenue divided by the number of orders |
| Gross margin | Profit divided by revenue. Profit here = meal price minus what Delivr pays the eatery |
| Retention rate | Share of last month's active users who ordered again this month |
| Stickiness | DAU divided by MAU: on what share of the days in a month the average user orders |
| Signup month | The month of a user's first order |

</details>

---

## 1. Growth

<img src="assets/report/01_growth.png" width="100%" alt="MAU, users added and growth rate per month"/>

- **MAU** (monthly active users) grew from 123 in June to 1,267 in December.
- Each month adds more users than the month before: +103 in July, +323 in December.
- But compared with the month before, growth fell from **84% to 34%**. The number of users added keeps rising only because the base keeps getting bigger. Looking at "users added" alone hides this slowdown.

<details>
<summary>Charts from the analysis notebooks (8)</summary>
<table>
<tr><td><img src="assets/analysis/mau_growth_absolute.png"/><br><sub>MAU added each month</sub></td><td><img src="assets/analysis/mau_growth_rate.png"/><br><sub>MAU growth rate vs the month before</sub></td></tr>
<tr><td><img src="assets/analysis/registrations_monthly.png"/><br><sub>New users (registrations) per month</sub></td><td><img src="assets/analysis/registrations_running_total.png"/><br><sub>Total registered users over time</sub></td></tr>
<tr><td><img src="assets/analysis/mau_rolling_30d.png"/><br><sub>Active users in the last 30 days (rolling MAU)</sub></td><td><img src="assets/analysis/wau_growth_rate.png"/><br><sub>WAU (weekly active users) growth rate. Peaks come about every 4 weeks</sub></td></tr>
<tr><td><img src="assets/analysis/revenue_by_month.png"/><br><sub>Revenue per month</sub></td><td><img src="assets/analysis/profit_by_month.png"/><br><sub>Profit per month</sub></td></tr>
</table>
</details>

## 2. Where the revenue growth came from

Monthly revenue went from \$6.3K in June to \$108.9K in December. Revenue is **active users × orders per user × average order value**, so the growth can be split between these three parts. The waterfall shows each part's fair share (the average over every order of changing the parts one at a time):

<img src="assets/report/02_revenue_waterfall.png" width="100%" alt="Waterfall of revenue growth by driver"/>
<img src="assets/report/03_per_user_vs_per_order.png" width="100%" alt="ARPU, orders per user, average order value and margin by month"/>

- **More users** added \$78.4K a month (76% of the growth). **More orders per user** added \$23.6K (23%). **Bigger orders** added only \$0.6K (1%).
- **ARPU** (average revenue per user) rose from \$51 to \$86. This came only from ordering more often: orders per user went from 2.29 to 3.80 (+66%).
- Average order value (\$22 to \$23) and gross margin (65%) did not change at all. Customers did not buy bigger or more expensive orders. This is the lever Delivr has not used yet.

<details>
<summary>Charts from the analysis notebooks (8)</summary>
<table>
<tr><td><img src="assets/analysis/arpu_monthly.png"/><br><sub>ARPU per month</sub></td><td><img src="assets/analysis/orders_per_user_monthly.png"/><br><sub>Average orders per user per month</sub></td></tr>
<tr><td><img src="assets/analysis/profit_per_user_monthly.png"/><br><sub>Average profit per user per month</sub></td><td><img src="assets/analysis/arpu_weekly.png"/><br><sub>ARPU per week</sub></td></tr>
<tr><td><img src="assets/analysis/stickiness_monthly.png"/><br><sub>Stickiness (DAU ÷ MAU) per month</sub></td><td><img src="assets/analysis/stickiness_by_eatery.png"/><br><sub>Stickiness per eatery</sub></td></tr>
<tr><td><img src="assets/analysis/order_growth_rate_monthly.png"/><br><sub>Order growth rate per month. Same shape as ARPU and stickiness</sub></td><td><img src="assets/analysis/order_growth_rate_weekly.png"/><br><sub>Order growth rate per week</sub></td></tr>
</table>
</details>

## 3. Loyalty

<img src="assets/report/04_active_user_types.png" width="100%" alt="Active users split into new, retained and resurrected"/>
<img src="assets/report/05_cohort_retention.png" width="100%" alt="Share of each signup month still active in later months"/>
<img src="assets/report/06_retention_and_frequency.png" width="100%" alt="Retention rate, days with an order and orders per customer"/>

- Each month's active users are **new** (first order this month), **retained** (also ordered last month) or **resurrected** (came back after skipping a month). In December, 72% were retained and only 22% were new.
- Grouping users by their **signup month** shows that customers almost never leave. The summer signups often skipped their second month (only 66% to 73% active), but most came back. By December every signup month was 94% to 98% active.
- The **retention rate** rose from 70% to 96%, and the average active user ordered on 2.2 days in June and 3.6 days in December.
- Only 7 of 1,304 customers ordered just once. Most ordered 5 to 10 times in seven months.

<details>
<summary>Charts from the analysis notebooks (3)</summary>
<table>
<tr><td><img src="assets/analysis/mau_breakdown.png"/><br><sub>Share of new, retained and resurrected users</sub></td><td><img src="assets/analysis/retention_monthly.png"/><br><sub>Retention rate per month</sub></td></tr>
<tr><td><img src="assets/analysis/retention_weekly.png"/><br><sub>Retention rate per week: 20 to 35% in summer, 56 to 59% in December</sub></td><td><img src="assets/analysis/orders_per_user_histogram.png"/><br><sub>Number of customers by total orders</sub></td></tr>
</table>
</details>

## 4. Eateries

<img src="assets/report/07_eatery_revenue_profit.png" width="100%" alt="Revenue split into profit and cost per eatery"/>
<img src="assets/report/08_meal_revenue_vs_profit.png" width="100%" alt="Revenue vs profit for each meal"/>

- Burgatorio sells the most (\$71.8K) but keeps only 52% of it. Bean Me Up Scotty sells less (\$60.7K) but keeps 77%, so it makes the most profit (\$46.9K).
- The same happens with single meals. Meal 5 (Burgatorio) is the best seller, but its margin is 38%. Meal 11 (Bean Me Up Scotty) sells 11% less and makes almost twice the profit.
- If Delivr ranks partners by revenue, it will promote the wrong ones. Meal 5's cost is worth a price talk with Burgatorio.

<img src="assets/report/09_life_of_pie.png" width="100%" alt="Life of Pie compared with the other eateries"/>

- **Life of Pie** keeps 88 cents of every dollar, the best on the platform. 86% of all customers tried it at least once.
- The problem is what happens next: only 2 of its meals sell, its retention is 60% (others: 76% to 83%), and its December customers spent \$10 each there (others: \$20 to \$29). More meals and more visibility would pay off well here.

<details>
<summary>Charts from the analysis notebooks (10)</summary>
<table>
<tr><td><img src="assets/analysis/revenue_by_eatery.png"/><br><sub>Revenue per eatery</sub></td><td><img src="assets/analysis/pareto_eatery_profit.png"/><br><sub>Profit per eatery (Pareto view)</sub></td></tr>
<tr><td><img src="assets/analysis/revenue_by_meal.png"/><br><sub>Revenue per meal</sub></td><td><img src="assets/analysis/pareto_meals_profit.png"/><br><sub>Profit per meal: 14 of 19 meals make 80% of profit</sub></td></tr>
<tr><td><img src="assets/analysis/retention_by_eatery.png"/><br><sub>Retention rate per eatery, monthly</sub></td><td><img src="assets/analysis/arpu_by_eatery.png"/><br><sub>ARPU per eatery, monthly</sub></td></tr>
<tr><td><img src="assets/analysis/order_growth_rate_by_eatery.png"/><br><sub>Order growth rate per eatery</sub></td><td><img src="assets/analysis/mau_rolling_30d_by_eatery.png"/><br><sub>Rolling 30-day MAU per eatery</sub></td></tr>
<tr><td><img src="assets/analysis/mau_rolling_30d_violin_by_eatery.png"/><br><sub>Spread of rolling MAU per eatery</sub></td><td><img src="assets/analysis/profit_vs_revenue_weekly.png"/><br><sub>Weekly profit vs revenue: a straight line, so the margin never changes</sub></td></tr>
</table>
</details>

## 5. Customers

<img src="assets/report/10_profit_concentration.png" width="100%" alt="Share of profit made by the top share of customers, orders, meals and eateries"/>
<img src="assets/report/11_profit_per_customer.png" width="100%" alt="Profit per customer by percentile group"/>

- A **Pareto analysis** sorts customers from most to least profit and adds up their share. The famous 80/20 rule says 20% of customers make 80% of the profit. At Delivr it takes **61%** of customers (and 59% of orders) to reach 80%.
- The typical customer brought in \$122 of profit (the median). Half of all customers are between \$78 and \$172. The top customer brought in \$408, only 0.2% of all profit.
- Revenue and profit per customer move in an almost perfect straight line, so there are no discount-heavy customers who spend a lot but earn Delivr little.

<details>
<summary>Charts from the analysis notebooks (7)</summary>
<table>
<tr><td><img src="assets/analysis/pareto_users_profit.png"/><br><sub>Profit per customer (Pareto view)</sub></td><td><img src="assets/analysis/pareto_orders_profit.png"/><br><sub>Profit per order (Pareto view)</sub></td></tr>
<tr><td><img src="assets/analysis/profit_per_user_histogram.png"/><br><sub>Customers by profit, in $10 steps</sub></td><td><img src="assets/analysis/profit_vs_revenue_per_user.png"/><br><sub>Profit vs revenue per customer (r² = 0.99)</sub></td></tr>
<tr><td><img src="assets/analysis/profit_buckets_fixed.png"/><br><sub>Customers in fixed profit groups</sub></td><td><img src="assets/analysis/profit_buckets_percentile.png"/><br><sub>Customers in percentile profit groups</sub></td></tr>
<tr><td><img src="assets/analysis/revenue_top10_customers.png"/><br><sub>Top 10 customers by revenue</sub></td><td><img src="assets/analysis/profit_top10_customers.png"/><br><sub>Top 10 customers by profit</sub></td></tr>
</table>
</details>

## 6. Timing

<img src="assets/report/12_signup_timing.png" width="100%" alt="New users by day of month and daily active users"/>

- 50% of all new users placed their first order in days 1 to 7 of a month. Day 1 alone brought 140 of them.
- **DAU** (daily active users) jumps right after the 1st of each month, most clearly on 1 November and 1 December.
- This looks like monthly marketing pushes (or it comes from how this fictional dataset was made). Either way, the first week of the month is when Delivr wins its new customers.

<details>
<summary>Charts from the analysis notebooks (2)</summary>
<table>
<tr><td><img src="assets/analysis/registrations_weekly.png"/><br><sub>New users per week: a peak about every 4 weeks</sub></td><td><img src="assets/analysis/dau_daily.png"/><br><sub>DAU per day</sub></td></tr>
</table>
</details>

---

## About the data

The dataset comes from DataCamp's *Analyzing Business Data in SQL* course. It has three tables:

```mermaid
erDiagram
    MEALS ||--o{ ORDERS : "ordered as"
    MEALS ||--o{ STOCK : "stocked as"
    MEALS {
        int meal_id PK
        text eatery
        float meal_price "what the customer pays"
        float meal_cost "what Delivr pays the eatery"
    }
    ORDERS {
        date order_date
        int user_id
        int order_id
        int meal_id FK
        int order_quantity
    }
    STOCK {
        date stocking_date
        int meal_id FK
        int stocked_quantity
    }
```

| Table | Rows | One row is |
|---|---:|---|
| `meals` | 20 | a meal on the menu, with its eatery, price and cost |
| `orders` | 28,672 | one meal inside an order (11,351 orders in total) |
| `stock` | 133 | a restocking of a meal (not used in this report) |

Things to keep in mind when reading the numbers:

- There is no signup table, so a user's signup date is the date of their first order.
- Profit only includes the meal price minus the meal cost. Delivery, marketing and staff costs are not in the data.
- Meal 19 (Life of Pie) is on the menu but was never ordered.
- The data is made up for teaching. Some patterns (retention near 96%, the jumps on the 1st of each month) are cleaner than a real business would show.

## What I would do next

- Add delivery and marketing costs to measure CAC (customer acquisition cost) and real profit per order.
- Test a bundle or minimum-order offer and measure the change in average order value.
- Use the `stock` table to find meals that are stocked but not sold.

---

## How the analysis is organised

```mermaid
flowchart LR
    DB[("PostgreSQL<br/>delivr")]
    DB --> N1["revenue-cost-profit"]
    DB --> N2["user-centric-KPI's"]
    DB --> N3["unit_economics"]
    DB --> N4["histograms_bucketing_<br/>percentiles_pareto_analysis"]
    N1 --> C["conclusions<br/>(this report)"]
    N2 --> C
    N3 --> C
    N4 --> C
    C --> R["README charts<br/>assets/report/"]
```

| Notebook | Question | SQL it uses |
|---|---|---|
| [`revenue-cost-profit`](revenue-cost-profit.ipynb) | Where does the money come from? Does more revenue mean more profit? | joins, `GROUP BY`, `date_trunc`, `SUM() OVER (PARTITION BY)` |
| [`user-centric-KPI's`](user-centric-KPI%27s.ipynb) | Are users growing, active and coming back? | CTEs, `LAG()`, running totals, self-joins for retention, `generate_series` for a rolling 30-day MAU |
| [`unit_economics`](unit_economics.ipynb) | Is each user worth more over time? | per-period ratios with `NULLIF` guards |
| [`histograms_bucketing_percentiles_pareto_analysis`](histograms_bucketing_percentiles_pareto_analysis.ipynb) | How is profit spread across users, orders, meals and eateries? | `CASE` buckets, `percentile_cont`, cumulative shares |
| [`conclusions`](conclusions.ipynb) | What does it all mean for the business? | signup-month (cohort) retention, `FILTER`, driver split of revenue growth |

All the aggregation runs in Postgres. Python only receives the final table and draws it.

---

## Under the hood: the Python and Postgres side

This part is for technical readers. It is what lets the whole project run on a clean machine with one command.

```mermaid
flowchart LR
    subgraph data["data/"]
        SQL["delivr.sql<br/>(schema)"]
        CSV["meals.csv<br/>orders.csv<br/>stock.csv"]
    end
    ENV[".env<br/>credentials"] --> CFG["db_config.py"]
    CFG --> SETUP["db_setup.py<br/>bootstrapper"]
    SQL --> SETUP
    CSV --> SETUP
    SETUP -->|"CREATE + COPY"| PG[("PostgreSQL 17")]
    CFG --> UTILS["utils/db_utils.py<br/>run_query()"]
    PG --> UTILS
    UTILS -->|"DataFrame"| NB["Jupyter notebooks"]
    PLOTS["utils/custom_plots.py<br/>Plotly chart library"] --> NB
    NB --> PNG["Static PNG charts<br/>(render on GitHub)"]
```

### `db_setup.py`: builds the database in one command

This script takes you from an empty Postgres server to a loaded `delivr` database. It is generic: the only project-specific part is a small `CONFIG` block (which SQL folder to run, which CSV goes into which table), so I can reuse it in other projects.

```mermaid
flowchart TD
    A["Plan: find the .sql files,<br/>read them, check the CSVs exist"] -->|"problem found"| X1["Stop. Database untouched"]
    A --> B["Show the plan and ask<br/>Proceed? yes / no"]
    B -->|"no"| X2["Exit. Nothing changed"]
    B -->|"yes"| C["Drop the old database<br/>(closes open connections first)"]
    C --> D["Create database"]
    D --> E["Run each .sql file in filename order"]
    E --> F["Stream each CSV into its table with COPY"]
    F --> G["Verify: count rows from<br/>the system catalog"]
    E -->|"error"| P["Report file:line:column<br/>and what already committed"]
    F -->|"error"| P
```

- It checks everything it can before deleting anything, so a typo in the config cannot wipe the old database and then fail to build the new one.
- CSVs go straight into Postgres through `COPY`, the fastest way to bulk-load. Values land exactly as written in the file, and memory stays flat however big the file is. An optional pandas mode fixes the common "186 became 186.0" bug for integer columns with gaps.
- When a SQL file fails, it shows the file, line and column, plus the broken line with a caret under the problem, instead of Postgres's bare `syntax error at or near`.
- It catches files that only the `psql` command-line tool can run (for example `\copy` or pg_dump's inline `COPY ... FROM stdin`) and explains what to change.
- At the end it reads the database back and lists every table with its real row count.

### `utils/db_utils.py`: SQL in, DataFrame out

A notebook cell looks like this:

```python
from utils.db_utils import run_query
from utils.custom_plots import line_plot

mau = run_query('''
    SELECT date_trunc('month', order_date)::date AS delivr_month,
           count(DISTINCT user_id)               AS mau
    FROM orders
    GROUP BY delivr_month
    ORDER BY delivr_month;
''')

line_plot(df=mau, x='delivr_month', y='mau', avg_line=True)
```

`run_query` reuses one shared SQLAlchemy connection to Postgres and returns the result as a pandas DataFrame. `execute_ddl` handles writes (`CREATE`, `UPDATE` and so on) inside a transaction that rolls back on error. Credentials live in a git-ignored `.env` file that `db_config.py` reads.

### `utils/custom_plots.py`: a personal chart library

About 4,700 lines of Plotly wrappers I wrote so every chart in the analysis notebooks has the same dark theme and needs one line to call: bar, line, scatter with an OLS fit, ECDF, violin and box, Pareto, heatmaps and more. The report charts in `conclusions.ipynb` use a colour-blind-safe palette and put the conclusion in the chart title. All notebooks render to static PNG (`pio.renderers.default = "png"`) so the charts show on GitHub. Remove that line to get interactive charts.

### Project structure

```
Delivr-Business-Analysis/
├── data/
│   ├── delivr.sql              # table definitions
│   ├── meals.csv
│   ├── orders.csv
│   └── stock.csv
├── utils/
│   ├── db_utils.py             # run_query / execute_ddl
│   └── custom_plots.py         # Plotly chart library
├── assets/
│   ├── report/                 # charts made by conclusions.ipynb
│   └── analysis/               # charts from the four analysis notebooks
├── db_config.py                # reads credentials from .env
├── db_setup.py                 # one-command database bootstrap
├── revenue-cost-profit.ipynb
├── user-centric-KPI's.ipynb
├── unit_economics.ipynb
├── histograms_bucketing_percentiles_pareto_analysis.ipynb
└── conclusions.ipynb           # the business report behind this README
```

### Run it yourself

You need PostgreSQL running locally and Python 3.11 or newer.

```bash
# 1. install dependencies (kaleido renders Plotly charts to PNG)
pip install pandas numpy scipy plotly kaleido sqlalchemy psycopg2-binary python-dotenv jupyterlab

# 2. create a .env file in the project root
DB_USER=postgres
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
DB_NAME=delivr

# 3. build and load the database (type "yes" at the prompt)
python db_setup.py

# 4. open the notebooks
jupyter lab
```

---

<sub>Dataset and KPI framework from DataCamp's <i>Analyzing Business Data in SQL</i> (first three chapters). The database tooling, chart library, analysis and report are my own.</sub>
