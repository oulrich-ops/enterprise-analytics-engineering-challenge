# Guide d'installation — de zéro à l'infrastructure provisionnée

## Prérequis
- Un compte Google Cloud avec facturation activée (crédit d'essai 300$/90 jours suffisant)
- Terraform >= 1.5
- gcloud CLI installé
- Python 3.10+

## 1. Créer le projet GCP
gcloud projects create <PROJECT_ID> --name="Enterprise Analytics Challenge"
gcloud config set project <PROJECT_ID>

## 2. Activer les APIs nécessaires
gcloud services enable iam.googleapis.com
gcloud services enable bigquery.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com

## 3. Créer le compte de service Terraform
gcloud iam service-accounts create terraform-runner --display-name="Terraform automation"

gcloud projects add-iam-policy-binding <PROJECT_ID> \
  --member="serviceAccount:terraform-runner@<PROJECT_ID>.iam.gserviceaccount.com" \
  --role="roles/editor"

gcloud projects add-iam-policy-binding <PROJECT_ID> \
  --member="serviceAccount:terraform-runner@<PROJECT_ID>.iam.gserviceaccount.com" \
  --role="roles/resourcemanager.projectIamAdmin"

gcloud iam service-accounts keys create terraform-key.json \
  --iam-account=terraform-runner@<PROJECT_ID>.iam.gserviceaccount.com

## 4. Configurer les credentials en local
# PowerShell
$env:GOOGLE_APPLICATION_CREDENTIALS="C:\secrets\terraform-key.json"

## 5. Provisionner l'infrastructure
cd terraform
cp terraform.tfvars.example terraform.tfvars   # renseigner project_id
terraform init
terraform plan
terraform apply


## Installation de dbt
python -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt