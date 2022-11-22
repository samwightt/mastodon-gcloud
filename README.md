# Terraform Google Cloud Mastodon

These are a set of Terraform files that will deploy a high-performance Mastodon cluster
on Google Cloud. It uses GKE, Cloud SQL, Cloud Storage, and Cloud CDN.

To deploy, copy `example.tfvars` to `main.tfvars`. Update the variables with your values
(see `vars.tf` in each directory for explanations of what they do.

Then deploy the `cluster` state:

```commandline
cd cluster
terraform apply -var-file=../main.tfvars
```

Once this is finished, deploy the `app` state:
```commandline
cd ../app
terraform apply -var-file=../main.tfvars
```