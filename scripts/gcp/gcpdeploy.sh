#!/bin/bash

export project_name=$(gcloud config get-value project)

declare -l vm_name
vm_name="mygcpvm-$(date +%s | sha256sum | base64 | head -c 8)"

gcloud compute instances create $vm_name --project=$project_name --zone=us-east1-b --machine-type=t2d-standard-1 --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=startup-script=\#\!/bin/bash$'\n'sudo\ apt-get\ update$'\n'sudo\ apt-get\ install\ -y\ apache2=2.4.29-1ubuntu4.27\ \ \#\ Install\ outdated\ Apache$'\n'sudo\ sed\ -i\ \'s/ServerTokens\ OS/ServerTokens\ Full/\'\ /etc/apache2/conf-available/security.conf\ \ \#\ Change\ ServerTokens$'\n'sudo\ sed\ -i\ \'s/ServerSignature\ On/ServerSignature\ Off/\'\ /etc/apache2/conf-available/security.conf$'\n'sudo\ apt-get\ install\ -y\ libssl1.0.0=1.0.2n-1ubuntu5\ libcurl3\ \ \#\ Install\ outdated\ libraries --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server --create-disk=auto-delete=yes,boot=yes,device-name=mygcpvm,image=projects/ubuntu-os-cloud/global/images/ubuntu-1804-bionic-v20240116a,mode=rw,size=10,type=projects/"$project_name"/zones/us-central1-a/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any

gcloud compute --project=$project_name firewall-rules create http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0

declare -l bucket_name
bucket_name="mybucket-$(date +%s | sha256sum | base64 | head -c 8)"
gsutil mb -p $project_name -c STANDARD -l us-east1 gs://$bucket_name/
gsutil iam ch allUsers:objectViewer gs://$bucket_name/ 
