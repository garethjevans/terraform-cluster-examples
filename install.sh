#!/bin/bash

set -euo pipefail

CLUSTER_NAME=gevans
SERVICE_ACCOUNT=jx-${CLUSTER_NAME}
ROLES="roles/compute.instanceAdmin.v1 roles/iam.serviceAccountActor roles/container.clusterAdmin"
KEY_DIR=.

GCP_PROJECT=$(gcloud config get-value project 2>/dev/null)
GCP_ZONE=$(gcloud config get-value compute/zone 2>/dev/null)
GCP_REGION=$(gcloud config get-value compute/region 2>/dev/null)
echo "Project ${GCP_PROJECT}"
echo "Region ${GCP_REGION}"
echo "Zone ${GCP_ZONE}"

# create service account if doesn't exist
if [[ $(gcloud iam service-accounts list --filter="${SERVICE_ACCOUNT}" | wc -l) -eq 0 ]]; then
	gcloud iam service-accounts create ${SERVICE_ACCOUNT}
fi

for ROLE in ${ROLES}; do
	gcloud projects add-iam-policy-binding ${GCP_PROJECT} \
		--member serviceAccount:${SERVICE_ACCOUNT}@${GCP_PROJECT}.iam.gserviceaccount.com \
		--role ${ROLE}
done

# download key if doesn't exist, store in .jx folder
if [ ! -f ${KEY_DIR}/${SERVICE_ACCOUNT}.key.json ]; then
	gcloud iam service-accounts keys create ${KEY_DIR}/${SERVICE_ACCOUNT}.key.json --iam-account ${SERVICE_ACCOUNT}@${GCP_PROJECT}.iam.gserviceaccount.com
fi

export GOOGLE_APPLICATION_CREDENTIALS=${KEY_DIR}/${SERVICE_ACCOUNT}.key.json

if [[ $(gcloud --project ${GCP_PROJECT} services list --enabled | grep -c "container.googleapis.com") -eq 0 ]]; then
	gcloud --project ${GCP_PROJECT} services enable "container.googleapis.com"
fi

terraform init gke
terraform plan \
  -state=${KEY_DIR}/${CLUSTER_NAME}.tfstate \
  -var "gcp_project=${GCP_PROJECT}" \
  -var "gcp_region=${GCP_REGION}" \
  -var "gcp_zone=${GCP_ZONE}" \
  -var "cluster_name=${CLUSTER_NAME}" \
  gke

terraform apply \
  -state=${KEY_DIR}/${CLUSTER_NAME}.tfstate \
  -var "gcp_project=${GCP_PROJECT}" \
  -var "gcp_region=${GCP_REGION}" \
  -var "gcp_zone=${GCP_ZONE}" \
  -var "cluster_name=${CLUSTER_NAME}" \
  gke

