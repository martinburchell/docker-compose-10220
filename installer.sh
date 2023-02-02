#!/bin/bash

# installer/installer.sh


set -eux -o pipefail

INSTALLER_HOME="$( cd "$( dirname "$0" )" && pwd )"

cd ${INSTALLER_HOME}
docker compose run --rm crate_workers /bin/bash -c "ls /crate/venv"
