# A simple CI/CD workflow with Travis CI and Kubernetes
[![Build Status](https://travis-ci.org/junaid-ali/test-cd.svg?branch=master)](https://travis-ci.org/junaid-ali/test-cd)

Variables to expose to Travis CI/CD job

|Var                            |Description                           |
|-------------------------------|--------------------------------------|
|`CI_ENV_K8S_CA`                |ca.crt of k8s cluster (base64 encoded)|
|`CI_ENV_K8S_MASTER`            |K8s api endpoint                      |
|`CI_ENV_K8S_SA_TOKEN`          |Service account token                 |
|`CI_ENV_REGISTRY_USER`         |Docker Hub username                   |
|`CI_ENV_REGISTRY_PASS`         |Docker Hub password                   |

Test line for Spinnaker - retry

Retry after token generation

Trigger still not working

Wow! I'm still trying to figure out the triggers

I hope it will work this time now

Man! this is driving me crazy
