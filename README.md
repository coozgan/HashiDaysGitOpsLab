# GitOps Learn Lab

This repository contains the Packer template, Terraform configuration, and application code to deploy [Terramino](https://github.com/hashicorp-education/terramino-go) and the Nomad cluster it runs on to AWS.

## Setup action secrets

The action to build and tag this repo requires the following secrets:

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION
- HCP_ORGANIZATION_ID
- HCP_PROJECT_ID
- HCP_CLIENT_ID
- HCP_CLIENT_SECRET
