#! /bin/bash

cwd=`cd "$(dirname "$0")" && pwd`

source $cwd/env.sh
$cwd/stop_all.sh

echo "Removing docker images"

function cleanImage() {
  local container_name="$1"

  docker images | grep -q ${NAMESPACE}$container_name && docker rmi ${NAMESPACE}$container_name
}

cleanImage kafka
cleanImage hadoop-client
cleanImage hadoop-worker
cleanImage hadoop-master
cleanImage hadoop-base
cleanImage base

echo "Done removing docker images"
