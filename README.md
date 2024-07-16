# quest

This project stands up two methods for deploying the quest app. First is Cloud Run, google's serverless container service. The second is via a Kubernetes deployment on GKE.

A Cloud Run Service is one of the simplest way to get this app up and running quickly and easily. A new service is created with a docker image built with the source code, and Google stands up all the necessary infrastructure behind the scenes, along with a unique domain name that can be used to access the service. Additionally there is a global loadbalancer deployed in front of the Cloud Run service secured with a Google manage SSL certificate.

The project also creates a GKE cluster in order to run a deployment with the quest app. In a real life scenario in which we wanted to just run this simple app an entire cluster would be overkill, and the costs of maintaining it wouldn't justify the advantages. But if there was a possibility of extending the app, needing to add resiliency, and ensure high availability, a Kubernetes cluster could be beneficial. The releases for this project are contained in the helmfiles/quest.yaml file. Alongside a release for the quest application, there is an nginx ingress deployment and a cert-manager deployment. The nginx ingress works in tandem with an ingress resource deployed in the quest app to configure a loadbalancer with an external IP address for the app. Cert-manager has been configured to generate TLS certificates for a custom domain procured for this project issued by lets-encrypt.

Stages to set up deployments:

1. Configure necessary infrastrucure

    Infrastructure to support the project is deployed to GCP via terraform. General variables such as project ID, region etc are set in the terraform/variables.tf file. To see what resources are set to be created run the "make plan" command. To apply those changes from "make apply".

2. Deploy the remaining terraform infrastructure and app image via CICD pipeline

    Github Actions was chosen as the CICD tool for this project. Github was already used to host the repository and so using Actions made the most sense to deploy out any changes made to the repo.

    On changes to the application code (imported into this project via submodule), a new image is built. At this stage the new image is deployed to Cloud Run as a new revision serving no traffic. This would allow testing of the new image before any customers are able to access the page. Once the PR has been approved and changes are merged, the new image is deployed to Cloud Run with all traffic. Deployment to GKE are manual at this time. The image tag in the values/quest.yaml file should be updated with the most recent image. The command "make diff" shows changes to be made to the deployment. Then "make deploy" deploys those changes out.

3. Procur and setup a new domain.

    For this project the domain name tryquests.xyz was used so that both deployments could be reached at a domain name rather than IP address. The domain name was bought through namecheap.

    After apply the terraform configuration it will output several pieces of information to be used to configure DNSSEC. From within the domain provider, the google nameservers must be added. Then DNSSEC must be turned on, and the DS record added.

At this point the GKE deployment of the app should be available at the base domain (tryquests.xyz). And the Cloud Run service is available at service.tryquests.xyz.


Given more time, I would improve...

1. I would automate the gke deployment. Ideally it would follow a similar process as the cloud run deploy. On pushes to feature branch with an open pull request the diff would be run to show you what changes would be made. Then once the PR was merged, the new image is built, the image tag value would be updated in place, then changes deployed out.
2. I'd like to find a way to automate infrastructure changes. A similar process to application changes would make sense. A PR would be opened with any updates. This would trigger an action that would run a plan to display changes to be made, ideally this would be attached to the PR. Then on PR merge those changes would be applied.
3. Use either a pre-built base image for the terraform github actions or caching to reduce the time the jobs take to run.
4. Implement some sort of secret manager that can bridge the gap between terraform and GKE. I've used a vault deployment in the past but Google managed secrets could be used as well.
5. Do more for Kubernetes security. The GKE cluster has the bare minimum in terms of security at the moment. Would be helpful to harden RBAC roles, add security contexts to deployment containers, and maybe network policies.