# Data Catalog - OpenMetadata

Local deployment of OpenMetadata, connected to BigQuery and dbt, for data discovery and governance across the project.

## What it covers

- Automatic scan of the `raw`, `staging`, and `marts` datasets
- Sync of descriptions and lineage from dbt (`manifest.json`, `catalog.json`)
- Business glossary: customer value, late delivery rate, repeat customer, average basket
- Three organizational domains: Sales, Logistics, Customer Satisfaction

## Run locally

```bash
cd openmetadata
docker compose up -d
```

UI available at http://localhost:8585
(default login: admin@open-metadata.org / admin)

## Requirements

- A dedicated GCP service account (`openmetadata-runner`) with these roles:
  `bigquery.dataViewer`, `bigquery.jobUser`, `bigquery.metadataViewer`,
  `bigquery.resourceViewer`, `datacatalog.viewer`, `storage.objectViewer`
- The JSON key for this account, to upload when configuring the BigQuery service in the UI

## Known issue

A documented bug in MySQL 8.0.32 (InnoDB foreign key assertion) prevents the default quickstart from starting correctly on some Docker environments. The PostgreSQL variant (official `docker-compose-postgres.yml`) works around this issue, which is why it is used here.

## Why local, not Cloud Run

OpenMetadata is a multi-service stack (server, database, search engine, ingestion), not a good fit for Cloud Run. A local deployment is enough for the demo. A real production setup would need Kubernetes or a Docker deployment on a dedicated VM.
