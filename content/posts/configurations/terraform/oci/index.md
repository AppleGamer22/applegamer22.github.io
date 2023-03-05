---
title: Oracle Cloud Infrastructure as Code
description: Oracle Cloud Infrastructure as Code
date: 2023-03-10
tags: [Terraform, OCI, IaC]
draft: true
---

```tf
terraform {
  required_version = ">= 1.3.6"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.104.0"
    }
  }
  cloud {
    organization = "applegamer22"
    workspaces {
      name = "oci"
    }
  }
}
```

```tf
variable "tenancy_ocid" {
  type      = string
  sensitive = true
}

variable "user_ocid" {
  type      = string
  sensitive = true
}

variable "fingerprint" {
  type      = string
  sensitive = true
}

variable "region_id" {
  type      = string
  sensitive = false
  default   = "ap-melbourne-1"
}

variable "private_rsa_key_path" {
  type      = string
  sensitive = true
  default   = "$HOME/.oci/oci.pem"
}
```

```tf
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  region           = var.region_id
  private_key_path = var.private_rsa_key_path
}
```

```tf
resource "oci_identity_compartment" "identity_compartment" {
  compartment_id = var.tenancy_ocid
  name           = "oci"
}

resource "oci_core_vcn" "vcn" {
  compartment_id = var.tenancy_ocid
  display_name   = "oci_vcn"
}

resource "oci_core_instance" "vm" {
  # Required
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.tenancy_ocid
  shape               = "VM.Standard2.1"
  source_details {
    source_id   = "Canonical-Ubuntu-22.04-Minimal-aarch64-2022.11.05-0"
    source_type = "image"
  }

  # Optional
  display_name = "oci_vm"
  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_vcn.vcn.id
  }
  metadata = {
    ssh_authorized_keys = file("$HOME/.ssh/id_rsa.pub")
  }
}
```