# Daily

## Infrastructure Prerequisites

Before using the terraform create the following resources
### 1. GCS bucket for terraform remote state backend
* Follow this [Store Terraform state in a Cloud Storage bucket](https://cloud.google.com/docs/terraform/resource-management/store-state)
* Set `terraform.backend.bucket` in `providers.tf`

### 2. Artifact registry for daily image
 * Set `artifact_repository_name` and `daily_image_name` in `deployment.yaml` workflow