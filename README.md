# jaffle_shop

## Project Description

This repo contains a self-contained dbt core project called **jaffle_shop** and the following seeds:

- Stripe_payments.csv
- Jaffle_shop_orders.csv
- Jaffle_shop_customers.csv

The project also comes with a single SQL file called **original_sql_to_refactor.sql**. 

The task is to:

*"Imagine you are creating a data pipeline, you receive a query and are tasked with refactoring it into our dbt project. We are aiming to stay as close as we can to the dbt style guide."*

## Running Project

To run this project:

1. Install dbt:

```
pip install dbt-snowflake==1.5.0
```

Once installed, execute the following command:

```
dbt
```

If the installation was successful you should see a help screen.

2. Clone this repository.

3. Change into the jaffle_shop directory from the command line:

```
cd jaffle_shop
```

## Tools Used

- Data Build Tool - dbt
- Data Warehouse - Snowflake



