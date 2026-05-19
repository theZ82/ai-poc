FROM python:3.12-slim

WORKDIR /dbt

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl libpq-dev gcc \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
    "dbt-core==1.9.0" \
    "dbt-postgres==1.9.0"

COPY . .

# Seed each CSV individually to avoid Windows Podman socket timeouts
# Then build star schema and run tests
CMD ["sh", "-c", "\
    dbt deps && \
    echo 'Seeding customers...' && \
    dbt seed --select olist_customers_dataset && \
    echo 'Seeding orders...' && \
    dbt seed --select olist_orders_dataset && \
    echo 'Seeding order items...' && \
    dbt seed --select olist_order_items_dataset && \
    echo 'Seeding payments...' && \
    dbt seed --select olist_order_payments_dataset && \
    echo 'Seeding reviews...' && \
    dbt seed --select olist_order_reviews_dataset && \
    echo 'Seeding products...' && \
    dbt seed --select olist_products_dataset && \
    echo 'Seeding sellers...' && \
    dbt seed --select olist_sellers_dataset && \
    echo 'Seeding translations...' && \
    dbt seed --select product_category_name_translation && \
    echo 'Building star schema...' && \
    dbt run && \
    echo 'Running tests...' && \
    dbt test \
    "]
