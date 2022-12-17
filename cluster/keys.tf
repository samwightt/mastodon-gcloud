##
## Key ring setup
##

# Set up keyring and key for Application-layer secrets encryption. GKE secrets are encrypted at rest,
# but if someone gets access to a dump of the etcd database, they can decrypt the secrets. Application-layer
# secrets encryption encrypts the secrets at the application-level, so even if someone gets access to the
# etcd database, they can't decrypt the secrets.
# https://cloud.google.com/kubernetes-engine/docs/how-to/encrypting-secrets

# Make a key and a key ring to use for application-layer secrets encryption.
# Note that the key ring and keys cannot be deleted once created.
resource "google_kms_key_ring" "ase_key_ring" {
  name = "${var.resource_prefix}-${var.encryption_key_ring_name}"
  location = var.gcp_region
  depends_on = [google_project_service.kms_api]
}

resource "google_kms_crypto_key" "ase_crypto_key" {
  name = "${var.resource_prefix}-${var.encryption_key_name}"
  key_ring = google_kms_key_ring.ase_key_ring.id
  # Set purpose to ENCRYPT_DECRYPT so that we can encrypt and decrypt secrets.
  purpose = "ENCRYPT_DECRYPT"
}


## 
## IAM policy bindings so that the GKE service account can access the KMS key.
##


# We need to attach a policy to the GKE service account to allow KMS key access. The format
# of the GKE service account is `service-<project-number>@container-engine-robot.iam.gserviceaccount.com`.
# We need the project number but we're passed the project ID, so use a data block to look it up.
data "google_project" "project" {
  project_id = var.gcp_project_id
}

locals {
  # The GKE service account is a special service account automatically created by GKE.
  # It has the format `service-<project-number>@container-engine-robot.iam.gserviceaccount.com`.
  gke_service_account_email = "service-${data.google_project.project.number}@container-engine-robot.iam.gserviceaccount.com"
}

# Policy binding for the cluster service account to access the KMS key.
# The role `roles/cloudkms.cryptoKeyEncrypterDecrypter` is required to encrypt and decrypt secrets.
# If we don't provide the right role, cluster creation fails.
resource "google_kms_crypto_key_iam_binding" "ase_key_binding" {
  # Pass the crypto key ID, not the crypto key ring name.
  crypto_key_id = google_kms_crypto_key.ase_crypto_key.id
  role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members = [
    # Add the GKE service account to the policy binding. We prefix it with `serviceAccount:` because
    # it is a service account.
    "serviceAccount:${local.gke_service_account_email}"
  ]
}