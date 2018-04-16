#!/bin/sh -e

usage() {
  echo ""
  echo "Export K8S cert and service account token"
  echo "usage: $(basename "$0") -n <namespace> -a <service_account>"
  echo "  -n|--namespace The namespace of the service account"
  echo "  -a|--account   The service account to export"
  echo ""
}

err() {
  printf "Please input both namespace and service_account.\\n"
}

while [ $# -gt 0 ]; do
  case $1 in
    -n | --namespace ) shift
      if [[ -z $1 ]];
      then
        NAMESPACE="cd"
      else
        NAMESPACE=$1
      fi
      ;;
    -a | --account ) shift
      if [[ -z $1 ]];
      then
        ACCOUNT_NAME="cd-agent"
      else
        ACCOUNT_NAME=$1
      fi
      ;;
    * ) usage
      exit 1
  esac
  shift
done

[[ -z $NAMESPACE ]] && NAMESPACE="cd"
[[ -z $ACCOUNT_NAME ]] && ACCOUNT_NAME="cd-agent"

# get API endpoint of current cluster
CURR_CXT=$(kubectl config current-context)
CURR_CLUSTER=$(kubectl config view -o jsonpath={.contexts[?\(@.name==\"$CURR_CXT\"\)].context.cluster})
API_ENDPOINT=$(kubectl config view -o jsonpath={.clusters[?\(@.name==\"$CURR_CLUSTER\"\)].cluster.server})
printf "API endpoint: \\n%s\\n" "$API_ENDPOINT"

kubectl get ns $NAMESPCE > /dev/null 2>&1
[[ $? -ne 0 ]] && kubectl create ns cd


kubectl get sa $ACCOUNT_NAME -n $NAMESPACE > /dev/null 2>&1
[[ $? -ne 0 ]] && kubectl create sa $ACCOUNT_NAME -n $NAMESPACE

kubectl apply -f ./cluster-role-and-binding.yml

ACCOUNT_SECRET=$(kubectl get sa ${ACCOUNT_NAME} -n ${NAMESPACE} -o jsonpath="{.secrets[].name}")
kubectl get secret ${ACCOUNT_SECRET} -n ${NAMESPACE} -o go-template='{{index .data "ca.crt"}}' | base64 --decode > ca.crt

SERVICE_ACCOUNT_TOKEN_IN_K8S=$(kubectl get secret ${ACCOUNT_SECRET} -n ${NAMESPACE} -o jsonpath="{.data['token']}" | base64 --decode)
echo "${SERVICE_ACCOUNT_TOKEN_IN_K8S}" > sa.token
printf "ca.crt and sa.token exported\\n"
