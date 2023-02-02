#!/bin/bash

# installer/installer.sh


set -eux -o pipefail

INSTALLER_HOME="$( cd "$( dirname "$0" )" && pwd )"
PROJECT_ROOT=${INSTALLER_HOME}/..

cd ${PROJECT_ROOT}/docker/dockerfiles
docker compose run --rm crate_workers /bin/bash -c "ls /crate/venv"
