#! /bin/bash

cwd=`cd "$(dirname "$0")" && pwd`

source $cwd/env.sh
$cwd/clean_all.sh

set -e

EXTN=".amv"

function cleanup {
  echo "Reverting Dockerfile mods.."
  for f in `find $cwd -name Dockerfile$EXTN -not -path $cwd/base/*`
  do
    mv $f $(dirname $f)/Dockerfile 
  done
  echo "Done reverting mods."
}

trap cleanup EXIT

for f in `find $cwd -name Dockerfile -not -path $cwd/base/*`
do
  echo "Modifying file : "$f
  ESC_NAMESPACE=$(echo $NAMESPACE | sed -e 's#/#\\/#g')
  sed -i$EXTN "/FROM  *${ESC_NAMESPACE}/b; s/FROM  */FROM ${ESC_NAMESPACE}/" $f
done

docker images | grep -q skydns  || docker pull crosbymichael/skydns
docker images | grep -q skydock || docker pull crosbymichael/skydock

docker build -t ${NAMESPACE}base base

docker build -t ${NAMESPACE}hadoop-base   hadoop/hadoop-base
docker build -t ${NAMESPACE}hadoop-worker hadoop/hadoop-worker
docker build -t ${NAMESPACE}hadoop-master hadoop/hadoop-master

docker build -t ${NAMESPACE}spark-master spark/spark-master
docker build -t ${NAMESPACE}spark-worker spark/spark-worker
docker build -t ${NAMESPACE}spark-client spark/spark-client

docker build -t ${NAMESPACE}kafka kafka
