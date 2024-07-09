#!/bin/bash

PROJECT_ID=justin-quest

gcloud iam service-accounts keys create key.json \
   --iam-account letsencrypt-google@$PROJECT_ID.iam.gserviceaccount.com

kubectl create ns quest

kubectl create secret generic letsencrypt-google -n quest \
   --from-file=key.json