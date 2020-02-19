######################################################################################
#   ____                   _         ____ _                 _
#  / ___| ___   ___   __ _| | ___   / ___| | ___  _   _  __| |
# | |  _ / _ \ / _ \ / _` | |/ _ \ | |   | |/ _ \| | | |/ _` |
# | |_| | (_) | (_) | (_| | |  __/ | |___| | (_) | |_| | (_| |
#  \____|\___/ \___/ \__, |_|\___|  \____|_|\___/ \__,_|\__,_|
#                    |___/
#  ____            _           _
# |  _ \ _ __ ___ (_) ___  ___| |_
# | |_) | '__/ _ \| |/ _ \/ __| __|
# |  __/| | | (_) | |  __/ (__| |_
# |_|   |_|  \___// |\___|\___|\__|
#               |__/
#  ___       _ _   _       _ _          _   _
# |_ _|_ __ (_) |_(_) __ _| (_)______ _| |_(_) ___  _ __
#  | || '_ \| | __| |/ _` | | |_  / _` | __| |/ _ \| '_ \
#  | || | | | | |_| | (_| | | |/ / (_| | |_| | (_) | | | |
# |___|_| |_|_|\__|_|\__,_|_|_/___\__,_|\__|_|\___/|_| |_|
# 
# Variables to set on the CI integration
#
#   * TF_VAR_project=example-project-terraform
#   * TF_VAR_region=us-central1
#   * TF_VAR_location=us-central
#   * TF_VAR_billing_account=xxxxxx-xxxxxx-xxxxxx
#   * TF_CREDS=./credentials-terraform.json
#
#   * GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}
#   * GOOGLE_CLOUD_KEYFILE_JSON=${TF_CREDS}
#   * GOOGLE_PROJECT=${TF_VAR_project}
######################################################################################

export TF_CREDS=./credentials-terraform.json

gcloud projects create ${TF_VAR_project} \
  --set-as-default

gcloud beta billing projects link ${TF_VAR_project} \
  --billing-account ${TF_VAR_billing_account}

######################################################################################
##### Create the Terraform service account
######################################################################################

gcloud iam service-accounts create terraform \
  --display-name "Terraform admin account"

gcloud iam service-accounts keys create ${TF_CREDS} \
  --iam-account terraform@${TF_VAR_project}.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding ${TF_VAR_project} \
  --member serviceAccount:terraform@${TF_VAR_project}.iam.gserviceaccount.com \
  --role roles/owner

gcloud projects add-iam-policy-binding ${TF_VAR_project} \
  --member serviceAccount:terraform@${TF_VAR_project}.iam.gserviceaccount.com \
  --role roles/storage.admin

gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable serviceusage.googleapis.com

######################################################################################
##### Set up remote state in Cloud Storage
######################################################################################

gsutil mb -p ${TF_VAR_project} gs://${TF_VAR_project}

cat > backend.tf << EOF
terraform {
 backend "gcs" {
   bucket  = "${TF_VAR_project}"
   prefix  = "terraform/state"
 }
}
EOF

gsutil versioning set on gs://${TF_VAR_project}

export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}
export GOOGLE_PROJECT=${TF_VAR_project}
export GOOGLE_CLOUD_KEYFILE_JSON=${TF_CREDS}