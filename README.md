# Terraform GCP project structure for user without organizations permission

Google Cloud Platform provides the following tutorial for creating the infrastructure: https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform, where in your oganization you have a project that admins other projects. In case you do not have cloud identity you cannot follows that architecture as the diagram proposed. The scope of this repository is providing an alternative to manage specific project.

This repositoy will mix:
* Bash scripts for creating the necessary project credentials and permission as well as deleting the project
* Terraform Scripts as example that will create some resources as well as adding services as needed

## Prerequisites

* Install google cloud sdk
* Install terraform

## Getting Started

First of all you will need to set the following environment variables:

* `TF_VAR_project`: the project name that is going to be created as for example `example-project-terraform`
* `TF_VAR_region`: Region name `us-central1`
* `TF_VAR_location`: Location id which is used for app engine `us-central`
* `TF_VAR_billing_account`: The terraform accoung which has the following structure: `xxxxxx-xxxxxx-xxxxxx`. To list your accounts you can simply do: `gcloud beta billing accounts list`
* `TF_CREDS`: The file that is generated with the google service credentials `./credentials-terraform.json`

Here are the Google specific environment variables

* `GOOGLE_APPLICATION_CREDENTIALS`=${TF_CREDS}
* `GOOGLE_CLOUD_KEYFILE_JSON`=${TF_CREDS}
* `GOOGLE_PROJECT`=${TF_VAR_project}

This tutorial will crate:
* GCP Project
* App engine with default application with hello world
* Activate firestore

So feel free to clone this project and modify as you needed. This is just a showcase on how I organize my terraform scripts and mix with bash to provide Infrastructure as a service for my personal projects.