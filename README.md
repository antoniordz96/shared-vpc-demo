# shared-vpc-demo
The purpose of this repo is to demonstrate how to deploy infrastructure on GCP via Terraform. At a high level we deploy:

1. Shared VPC network (Host Project resides in Management Folder & Service Projects in application folder)
2. 4 subnets (5 total to show how easy to add subnets) in a single region for simplicity
3. Firewall rules to allow internal network connectivity, SSH and Web access from external internet on certain resources.
4. Bastion Host that resides in subnet 01
5. MIG running apache web server that resides in subnet 03 that cannot be accessed via the public internet. 
6. HTTP Load balancer that exposes the apache webserver on port 80 and forwards the incoming traffic to the backend server. 

## Architecture Diagram
TODO(antoniordz96) add architecture diagram

## Compatibility

This repo is meant for use with Terraform 0.13.7. You can manage different versions of terraform in the local 
workstation using [tfenv](https://github.com/tfutils/tfenv).

##  Prerequisites and Tools
* [Bootstrap a GCP organization](https://github.com/terraform-google-modules/terraform-google-bootstrap), creating all 
the required GCP resources & permissions to start using the 
Cloud Foundation Toolkit (CFT). You will be running this through the [terraform seed SA](https://github.com/terraform-google-modules/terraform-google-project-factory/blob/master/docs/GLOSSARY.md#seed-service-account)
* GCP Organization
* [Terraform](https://github.com/tfutils/tfenv)
* [gcloud](https://cloud.google.com/sdk/docs/install)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> v0.13.7 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 3.76.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | 3.76.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 3.76.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |
| <a name="provider_template"></a> [template](#provider\_template) | ~> 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_host_project"></a> [host\_project](#module\_host\_project) | terraform-google-modules/project-factory/google | ~> 11.1.0 |
| <a name="module_http-lb"></a> [http-lb](#module\_http-lb) | GoogleCloudPlatform/lb-http/google | 6.0.1 |
| <a name="module_mig"></a> [mig](#module\_mig) | terraform-google-modules/vm/google//modules/mig | 6.2.0 |
| <a name="module_mig_template"></a> [mig\_template](#module\_mig\_template) | terraform-google-modules/vm/google//modules/instance_template | 6.2.0 |
| <a name="module_networking"></a> [networking](#module\_networking) | ./modules/network | n/a |
| <a name="module_service-project"></a> [service-project](#module\_service-project) | terraform-google-modules/project-factory/google//modules/svpc_service_project | ~> 11.1.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_instance.instance](https://registry.terraform.io/providers/hashicorp/google/3.76.0/docs/resources/compute_instance) | resource |
| [google_folder.application](https://registry.terraform.io/providers/hashicorp/google/3.76.0/docs/resources/folder) | resource |
| [google_folder.management](https://registry.terraform.io/providers/hashicorp/google/3.76.0/docs/resources/folder) | resource |
| [google_project_iam_member.project](https://registry.terraform.io/providers/hashicorp/google/3.76.0/docs/resources/project_iam_member) | resource |
| [random_id.default](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/id) | resource |
| [google_compute_image.redhat_image](https://registry.terraform.io/providers/hashicorp/google/3.76.0/docs/data-sources/compute_image) | data source |
| [template_file.application](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_account_id"></a> [billing\_account\_id](#input\_billing\_account\_id) | Billing Account to associate resources to. | `string` | n/a | yes |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | GCP organization ID. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP Region to deploy resources. | `string` | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_external_ip"></a> [application\_external\_ip](#output\_application\_external\_ip) | HTTP Load Balancer external IP for reaching Apache Web Server. |
| <a name="output_host_project"></a> [host\_project](#output\_host\_project) | Host Project ID. |
| <a name="output_service_project"></a> [service\_project](#output\_service\_project) | Service Project ID. |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Subnets created in environment. |

## Usage 

```bash
# Downloading Repo
git clone https://github.com/antoniordz96/shared-vpc-demo.git
cd shared-vpc-demo

# Configuring Terraform
tfenv install 0.13.7
tfenv use 0.13.7
terraform version

# Configuring gcloud
gcloud auth login

# Using terraform seed project and SA
gcloud config set project $TERRAFORM_SEED_PROJECT
gcloud iam service-accounts keys create key.json --iam-account={terraform-seed-sa}@project-id.iam.gserviceaccount.com
export GOOGLE_APPLICATION_CREDENTIALS=${SERVICE_ACCOUNT_KEY_PATH}

# remember to set input variables. Use terraform.tfvars
touch terraform.tfvars
terraform init
terraform plan
terraform apply
```

Note: You do not necessarily need to download the seed SA. One can perform service account impersonation and run 
terraform to deploy the resources. For more info see 
[public docs](https://cloud.google.com/iam/docs/impersonating-service-accounts).
