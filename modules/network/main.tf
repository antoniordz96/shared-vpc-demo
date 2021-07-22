/******************************************
  Network Configuration
*****************************************/
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 3.2.2"

  # insert the 2 required variables here
  network_name = var.network_name
  project_id   = var.host_project_id

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.0.0.0/24"
      subnet_region = var.region
      description   = "Public Subnet"
    },
    {
      subnet_name   = "subnet-02"
      subnet_ip     = "10.0.1.0/24"
      subnet_region = var.region
      description   = "Public Subnet"
    },
    {
      subnet_name           = "subnet-03"
      subnet_ip             = "10.0.2.0/24"
      subnet_private_access = true
      subnet_region         = var.region
      description           = "Private Subnet"
    },
    {
      subnet_name           = "subnet-04"
      subnet_ip             = "10.0.3.0/24"
      subnet_private_access = true
      subnet_region         = var.region
      description           = "Private Subnet"
    },
    {
      subnet_name           = "subnet-05"
      subnet_ip             = "10.0.4.0/24"
      subnet_private_access = true
      subnet_region         = var.region
      description           = "Private Subnet"
    },
  ]
}

resource "google_compute_firewall" "allow-internal" {
  name    = "${module.vpc.network_name}-allow-internal"
  network = module.vpc.network_self_link
  project = var.host_project_id

  allow {
    protocol = "all"
  }
  priority = 999

  source_ranges = ["10.0.0.0/9"]
}

resource "google_compute_firewall" "allow-web" {
  name    = "${module.vpc.network_name}-allow-web"
  network = module.vpc.network_self_link
  project = var.host_project_id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  priority      = 1000
  target_tags   = ["web"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "${module.vpc.network_name}-allow-ssh"
  network = module.vpc.network_self_link
  project = var.host_project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  priority      = 1000
  target_tags   = ["ssh"]
  source_ranges = ["0.0.0.0/0"]
}

// Instance with only internal IP address tries to access external hosts will fail.
// cloud NAT is must be enabled in the subnet
resource "google_compute_router" "default" {
  name    = "lb-http-router"
  network = module.vpc.network_self_link
  region  = var.region
  project = var.host_project_id
}

module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "1.0.0"
  router     = google_compute_router.default.name
  project_id = var.host_project_id
  region     = var.region
  name       = "cloud-nat-lb-http-router"
}