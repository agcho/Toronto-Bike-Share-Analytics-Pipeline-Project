variable "credentials" {
  description = "My Credentials"
  default     = "../keys/my-creds.json"
}

variable "project" {
  description = "Project"
  default     = "dtc-de-course-486019"
}

variable "region" {
  description = "Region"
  default     = "us-central1"
}

variable "location" {
  description = "Project Location"
  default     = "us-central1"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "bikeshare_raw_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "toronto-bike-share-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}
