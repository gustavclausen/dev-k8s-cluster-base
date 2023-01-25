#!/usr/bin/env bash

set -e

function usage() {
  cat <<EOF
---
USAGE

$0 -n <app name> -v <app version> -s <Path/URL to CRD source> [-fh]

Ensures that the Custom Resource Definitions (CRDs) for the given application
are installed.

Required arguments:
-n Name of application to find CRDs for (defined in 'app.kubernetes.io/name' label).
-v Version of application to find CRDs for (defined in 'app.kubernetes.io/version' label).
-s Path/URL to CRD source (e.g. './crds/my-crd.yaml' or
   'https://github.com/acme/product/releases/download/v1.1.1/crd.yaml').

Optional flags:
-f Force apply CRD.
-h Show this help message.

EOF
}

function fail() {
  if [ -n "$1" ]; then
    echo "ERROR: $1"
  fi

  if [ -z "$2" ]; then
    echo ""
    usage
  fi

  if [ -n "$1" ]; then
    exit 1
  fi
}

required_executables="kubectl"

for required_executable in $required_executables; do
  if ! command -v "$required_executable" &>/dev/null; then
    fail "Required execuable '$required_executable' not found." "skip"
  fi
done

declare force_apply=false

while getopts :n:v:s:fh flag; do
  case "${flag}" in
  n) app_name=${OPTARG} ;;
  v) app_version=${OPTARG} ;;
  s) crd_source=${OPTARG} ;;
  f) force_apply=true ;;
  h) usage && exit ;;
  *) fail "Unknown argument: -$OPTARG" ;;
  esac
done

if [[ -z "$app_name" ]]; then
  fail "App name not set. See usage."
fi

if [[ -z "$app_version" ]]; then
  fail "App version not set. See usage."
fi

if [[ -z "$crd_source" ]]; then
  fail "CRD source not set. See usage."
fi

crds=$(kubectl get crd -l "app.kubernetes.io/name=$app_name,app.kubernetes.io/version=$app_version" --output name)
if [ $force_apply == true ] || [ -z "$crds" ]; then
  kubectl apply -f "$crd_source"
  echo "CRDs are now installed!"
else
  echo "CRDs are already installed!"
fi
