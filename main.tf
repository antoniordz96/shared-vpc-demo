locals {
  family = "rhel-7"
  project = "rhel-cloud"
  service_account_roles = ["roles/logging.logWriter", "roles/monitoring.metricWriter"]
}

data "google_compute_image" "redhat_image" {
  family  = local.family
  project = local.project
}

data "template_file" "application" {
  template = file(format("%s/scripts/apache.sh.tpl", path.root))
  vars = {
    index_file = file(format("%s/scripts/index.php", path.root))
  }
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
  activate_apis = ["compute.googleapis.com", "logging.googleapis.com"]
  depends_on = [module.host_project]
}

resource "google_project_iam_member" "project" {
  project = module.service-project.project_id
  role    = each.key
  member  = "serviceAccount:${module.service-project.service_account_email}"
  for_each = toset(local.service_account_roles)
  depends_on = [module.service-project]
}

/******************************************
  Application Deployment
*****************************************/

// Bastion Host
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

// Apache MIG served by HTTP LB
module "mig_template" {
  source             = "terraform-google-modules/vm/google//modules/instance_template"
  version            = "6.2.0"

  disk_size_gb = 20
  disk_type = "pd-standard"
  machine_type = "e2-standard-2"
  network            = module.networking.network_self_link
  subnetwork         = "subnet-03"
  region = var.region
  subnetwork_project = module.host_project.project_id
  service_account = {
    email  = module.service-project.service_account_email
    scopes = ["cloud-platform"]
  }
  name_prefix    = "apache-mig"
  startup_script = data.template_file.application.rendered
  source_image_family = local.family
  source_image_project = local.project
  tags           = ["web"]
  project_id = module.service-project.project_id
}

module "mig" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "6.2.0"

  hostname = "apache"
  instance_template = module.mig_template.self_link
  region            = var.region
  target_size       = 2
  min_replicas = 1
  named_ports = [{
    name = "http",
    port = 80
  }]
  project_id = module.service-project.project_id
  depends_on = [module.networking]
}

module "http-lb" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "6.0.1"

  name = "http-lb"
  project           = module.service-project.project_id
  target_tags       = ["web"]
  firewall_projects = [module.host_project.project_id]
  firewall_networks = [module.networking.network_self_link]

  backends = {
    default = {
      description                     = null
      protocol                        = "HTTP"
      port                            = 80
      port_name                       = "http"
      timeout_sec                     = 10
      connection_draining_timeout_sec = null
      enable_cdn                      = false
      security_policy                 = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null
      custom_request_headers          = null
      custom_response_headers         = null

      health_check = {
        check_interval_sec  = 30
        timeout_sec         = 15
        healthy_threshold   = null
        unhealthy_threshold = null
        request_path        = "/"
        port                = 80
        host                = null
        logging             = true
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        {
          group                        = module.mig.instance_group
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        }
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
    }
  }
}
