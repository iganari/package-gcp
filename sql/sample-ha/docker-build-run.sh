#!/bin/bash

set -xeu

_I_TAG='sql-sample-mysql'
BASEPATH=$(cd `dirname $0`; pwd)
DIREPATH=`echo $BASEPATH | awk -F\/ '{print $NF}'`

set +eu
docker rm -f ${_I_TAG}
set -eu

docker build . -t ${_I_TAG}

docker run --rm \
           -it \
           -v $BASEPATH:/opt/iganari/$DIREPATH \
           -w /opt/iganari/$DIREPATH \
           -h ${_I_TAG} \
           --name ${_I_TAG} \
           ${_I_TAG} \
           /bin/bash
