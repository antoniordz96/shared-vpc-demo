data "google_compute_image" "redhat_image" {
  family  = "rhel-8"
  project = "rhel-cloud"
}

resource "random_id" "default" {
  byte_length = 4
}

/******************************************
  Folder Project Creation
*****************************************/
resource "google_folder" "management" {
  display_name = "management-${random_id.default.hex}"
  parent       = "organizations/${var.organization_id}"
}

resource "google_folder" "application" {
  display_name = "application-${random_id.default.hex}"
  parent       = "organizations/${var.organization_id}"
}

/******************************************
  Host Project Creation
*****************************************/
module "host_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 11.1.0"

  billing_account                = var.billing_account_id
  name                           = "host-${random_id.default.hex}"
  org_id                         = var.organization_id
  folder_id                      = google_folder.management.id
  enable_shared_vpc_host_project = true
  disable_services_on_destroy    = false
}

/******************************************
  Network Configuration
*****************************************/
module "networking" {
  source          = "./modules/network"
  host_project_id = module.host_project.project_id
  region          = var.region
}


/******************************************
  Service Project Configuration
*****************************************/
module "service-project" {
  source  = "terraform-google-modules/project-factory/google//modules/svpc_service_project"
  version = "~> 11.1.0"

  name = "sp-${random_id.default.hex}"

  org_id             = var.organization_id
  folder_id          = google_folder.application.id
  billing_account    = var.billing_account_id
  shared_vpc         = module.host_project.project_id
  shared_vpc_subnets = module.networking.subnet_self_links

  disable_services_on_destroy = false
}

resource "google_compute_instance" "instance" {
  machine_type = "e2-small"
  name         = "bastion-host"
  project      = module.service-project.project_id
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      size  = 20
      type  = "pd-standard"
      image = data.google_compute_image.redhat_image.self_link
    }
  }
  network_interface {
    subnetwork         = "subnet-01"
    subnetwork_project = module.host_project.project_id
    access_config {

    }
  }
  service_account {
    email  = module.service-project.service_account_email
    scopes = ["cloud-platform"]
  }
  tags = ["ssh"]
}


