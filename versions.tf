terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "3.76.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "3.76.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
  }

  required_version = "~> v0.13.7"
}