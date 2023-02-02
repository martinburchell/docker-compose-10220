#!/bin/bash

# installer/installer.sh


set -eux -o pipefail

INSTALLER_HOME="$( cd "$( dirname "$0" )" && pwd )"

cd ${INSTALLER_HOME}
docker compose run --rm test /bin/bash -c "ls /test/foo"
