import pandas as pd
import great_expectations as gx

context = gx.get_context(mode="file", project_root_dir=".")
data_source = context.data_sources.add_or_update_pandas("olist_raw_datasource")

# Configuration : un dict par fichier, avec ses propres règles
FILES_CONFIG = {
    "order_reviews": {
        "path": "../ingestion/raw_data/olist_order_reviews_dataset.csv",
        "expectations": [
            gx.expectations.ExpectColumnValuesToBeUnique(column="review_id"),
            gx.expectations.ExpectColumnValuesToNotBeNull(column="review_id"),
            gx.expectations.ExpectColumnValuesToNotBeNull(column="order_id"),
            gx.expectations.ExpectColumnValuesToBeBetween(column="review_score", min_value=1, max_value=5),
        ],
    },
    "orders": {
        "path": "../ingestion/raw_data/olist_orders_dataset.csv",
        "expectations": [
            gx.expectations.ExpectColumnValuesToBeUnique(column="order_id"),
            gx.expectations.ExpectColumnValuesToNotBeNull(column="customer_id"),
        ],
    },
    "customers": {
        "path": "../ingestion/raw_data/olist_customers_dataset.csv",
        "expectations": [
            gx.expectations.ExpectColumnValuesToBeUnique(column="customer_id"),
            gx.expectations.ExpectColumnValuesToNotBeNull(column="customer_unique_id"),
        ],
    },
    "order_items": {
        "path": "../ingestion/raw_data/olist_order_items_dataset.csv",
        "expectations": [
            gx.expectations.ExpectColumnValuesToNotBeNull(column="order_id"),
            gx.expectations.ExpectColumnValuesToNotBeNull(column="product_id"),
            gx.expectations.ExpectColumnValuesToBeBetween(column="price", min_value=0),
        ],
    },
    "sellers": {
        "path": "../ingestion/raw_data/olist_sellers_dataset.csv",
        "expectations": [
            gx.expectations.ExpectColumnValuesToBeUnique(column="seller_id"),
            gx.expectations.ExpectColumnValuesToNotBeNull(column="seller_state"),
        ],
    },
    "products": {
        "path": "../ingestion/raw_data/olist_products_dataset.csv",
        "expectations": [
            gx.expectations.ExpectColumnValuesToBeUnique(column="product_id"),
        ],
    },
    "order_payments": {
        "path": "../ingestion/raw_data/olist_order_payments_dataset.csv",
        "expectations": [
            gx.expectations.ExpectColumnValuesToNotBeNull(column="order_id"),
            gx.expectations.ExpectColumnValuesToBeBetween(column="payment_value", min_value=0),
            gx.expectations.ExpectColumnValuesToBeBetween(column="payment_installments", min_value=0),
        ],
    },
    "geolocation": {
        "path": "../ingestion/raw_data/olist_geolocation_dataset.csv",
        "expectations": [
            gx.expectations.ExpectColumnValuesToNotBeNull(column="geolocation_zip_code_prefix"),
            gx.expectations.ExpectColumnValuesToBeBetween(column="geolocation_lat", min_value=-35, max_value=6),
            gx.expectations.ExpectColumnValuesToBeBetween(column="geolocation_lng", min_value=-75, max_value=-30),
        ],
    },
}

results_summary = []

for name, cfg in FILES_CONFIG.items():
    df = pd.read_csv(cfg["path"])

    asset_name = f"{name}_asset"
    try:
        data_asset = data_source.get_asset(asset_name)
    except Exception:
        data_asset = data_source.add_dataframe_asset(name=asset_name)

    batch_def_name = f"{name}_batch"
    try:
        batch_definition = data_asset.get_batch_definition(batch_def_name)
    except Exception:
        batch_definition = data_asset.add_batch_definition_whole_dataframe(batch_def_name)

    suite_name = f"{name}_suite"
    try:
        context.suites.delete(suite_name)
    except Exception:
        pass
    suite = gx.ExpectationSuite(name=suite_name)
    suite = context.suites.add(suite)
    for exp in cfg["expectations"]:
        suite.add_expectation(exp)

    validation_name = f"{name}_validation"
    try:
        context.validation_definitions.delete(validation_name)
    except Exception:
        pass
    validation_definition = gx.ValidationDefinition(data=batch_definition, suite=suite, name=validation_name)
    validation_definition = context.validation_definitions.add(validation_definition)

    result = validation_definition.run(batch_parameters={"dataframe": df})
    results_summary.append((name, result.success))
    status = "OK" if result.success else "ECHEC"
    print(f"{name}: {status}")

context.build_data_docs()
context.open_data_docs()

print("\nResume de validation :")
for name, success in results_summary:
    status = "reussi" if success else "echoue"
    print(f" - {name}: {status}")