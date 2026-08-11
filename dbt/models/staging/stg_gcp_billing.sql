select
    service.description as service_name,
    sku.description as sku_name,
    usage_start_time,
    usage_end_time,
    cost,
    currency,
    project.id as project_id

from `{{ target.project }}.billing_export.{{ var("billing_export_table") }}`