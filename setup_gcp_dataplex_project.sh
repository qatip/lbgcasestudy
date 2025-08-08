#!/bin/bash

# Set variables
PROJECT_ID="your-gcp-project-id"
BUCKET_NAME="your-bucket-name"
DATASET="your_dataset"
LOCATION="europe-west1"

# Enable APIs
gcloud services enable \
  storage.googleapis.com \
  dataplex.googleapis.com \
  bigquery.googleapis.com \
  bigquerystorage.googleapis.com \
  aiplatform.googleapis.com

# Create GCS bucket
gsutil mb -l $LOCATION gs://$BUCKET_NAME

# Upload files
gsutil cp customers.csv transactions.csv support_logs.csv gs://$BUCKET_NAME/raw/

# Create BigQuery dataset
bq mk --location=$LOCATION $DATASET

# Load CSVs into BigQuery
bq load --autodetect --skip_leading_rows=1 \
  $DATASET.customers \
  gs://$BUCKET_NAME/raw/customers.csv

bq load --autodetect --skip_leading_rows=1 \
  $DATASET.transactions \
  gs://$BUCKET_NAME/raw/transactions.csv

bq load --autodetect --skip_leading_rows=1 \
  $DATASET.support_logs \
  gs://$BUCKET_NAME/raw/support_logs.csv
