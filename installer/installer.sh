#!/bin/bash

set -eux -o pipefail

INSTALLER_HOME="$( cd "$( dirname "$0" )" && pwd )"
INSTALLER_VENV=${HOME}/.virtualenvs/installer

# Create installer virtual environment
if [ ! -d "${INSTALLER_VENV}" ]; then
    python3 -m venv "${INSTALLER_VENV}"
fi

# Activate virtual environment
source "${INSTALLER_VENV}/bin/activate"

python -m pip install -U pip setuptools
python -m pip install -r "${INSTALLER_HOME}/installer-requirements.txt"

# Run the Python installer
python "${INSTALLER_HOME}/installer.py"
