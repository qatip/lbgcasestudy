
resource "google_dataplex_lake" "lake" {
  name     = "banking-lake"
  project  = var.project_id
  location = var.region
  labels = {
    environment = "case-study"
  }
  lake_id = "banking-lake"
}

resource "google_dataplex_zone" "raw_zone" {
  name     = "raw-zone"
  location = var.region
  project  = var.project_id
  lake     = google_dataplex_lake.lake.name
  zone_id  = "raw-zone"

  type = "RAW"

  discovery_spec {
    enabled = true
  }

  resource_spec {
    name = google_storage_bucket.data_bucket.name
    type = "STORAGE_BUCKET"
  }
}

resource "google_project_iam_member" "dataplex_reader" {
  project = var.project_id
  role    = "roles/dataplex.viewer"
  member  = "user:${var.dataplex_user}"
}

resource "null_resource" "upload_sample_data" {
  provisioner "local-exec" {
    command = <<EOT
      gsutil cp customers.csv gs://${var.bucket_name}/raw/
      gsutil cp transactions.csv gs://${var.bucket_name}/raw/
      gsutil cp support_logs.csv gs://${var.bucket_name}/raw/
    EOT
  }
}

resource "google_dataplex_asset" "customers_asset" {
  name     = "customers"
  asset_id = "customers"
  location = var.region
  lake     = google_dataplex_lake.lake.name
  zone     = google_dataplex_zone.raw_zone.name
  project  = var.project_id

  discovery_spec {
    enabled = true
  }

  resource_spec {
    name = "projects/${var.project_id}/datasets/${var.dataset_id}/tables/customers"
    type = "BIGQUERY_TABLE"
  }
}

resource "google_dataplex_asset" "transactions_asset" {
  name     = "transactions"
  asset_id = "transactions"
  location = var.region
  lake     = google_dataplex_lake.lake.name
  zone     = google_dataplex_zone.raw_zone.name
  project  = var.project_id

  discovery_spec {
    enabled = true
  }

  resource_spec {
    name = "projects/${var.project_id}/datasets/${var.dataset_id}/tables/transactions"
    type = "BIGQUERY_TABLE"
  }
}

resource "google_dataplex_asset" "support_logs_asset" {
  name     = "support_logs"
  asset_id = "support-logs"
  location = var.region
  lake     = google_dataplex_lake.lake.name
  zone     = google_dataplex_zone.raw_zone.name
  project  = var.project_id

  discovery_spec {
    enabled = true
  }

  resource_spec {
    name = "projects/${var.project_id}/datasets/${var.dataset_id}/tables/support_logs"
    type = "BIGQUERY_TABLE"
  }
}
