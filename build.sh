#!/bin/bash
buildImageName="acr-cred-helper-build-img"
buildContainerName="acr-cred-helper-build"

if [[ "$(docker images -q ${buildImageName} 2> /dev/null)" == "" ]]; then
    docker rmi -f ${buildImageName}
fi

set -e
./build/build-clean.sh bin artifacts

docker build -t ${buildImageName} .
docker run --name ${buildContainerName} ${buildImageName}
docker cp ${buildContainerName}:/build-root/artifacts artifacts

docker rm ${buildContainerName}
docker rmi ${buildImageName}
