#!/bin/bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -c|--channels) CHANNELS="$2" ; shift;shift ;;
    -h|--help)
      cat <<HELPMSG
$0 [option...]

Using the settings passed to this script, this will print to stdout a new bundle.Dockerfile generated from the template.

Valid options:
  -c|--channels <channel list>
      A comma-separate list of channels that will be associated with the bundle.
      The first channel in the list will be considered the default channel.
      Default: candidate
HELPMSG
      exit 1
      ;;
    *)
      echo "Unknown argument [$key].  Aborting."
      exit 1
      ;;
  esac
done

BUNDLE_DOCKERFILE="$(ls -1 ${SCRIPT_DIR}/template/bundle.Dockerfile)"
if [ -z ${BUNDLE_DOCKERFILE} ]; then
  echo "Something is wrong. Cannot find the template bundle.Dockerfile at ${SCRIPT_DIR}/template/bundle.Dockerfile"
  exit 1
fi

# Generate the new annotations.yaml content from the template
export CHANNELS="${CHANNELS:-candidate}"
export DEFAULT_CHANNEL="$(echo ${CHANNELS} | cut -d ',' -f1)"
cat ${BUNDLE_DOCKERFILE} | envsubst