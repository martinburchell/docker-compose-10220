#!/bin/bash

# installer/installer.sh

# ==============================================================================
#
#     Copyright (C) 2015, University of Cambridge, Department of Psychiatry.
#     Created by Rudolf Cardinal (rnc1001@cam.ac.uk).
#
#     This file is part of CRATE.
#
#     CRATE is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     CRATE is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with CRATE. If not, see <https://www.gnu.org/licenses/>.
#
# ==============================================================================

# Installs CRATE running under Docker with demonstration databases.
# Do as little as possible in this script.
# Do as much as possible in installer.py.

set -eux -o pipefail

# - Prerequisites for Windows:
#   - Install WSL2
#   - Install Docker Desktop for Windows
#   - Enable WSL2 in Docker Desktop
#
# - Prerequisites for Ubuntu:
#     sudo apt-get update
#     sudo apt -y install python3-virtualenv python3-venv

# When called with no arguments, the installation process is as in docker.rst
# With the -d (development) option, the installer runs on the local copy of the
# source code.


# -----------------------------------------------------------------------------
# Directories
# -----------------------------------------------------------------------------
CRATE_INSTALLER_VENV=${HOME}/.virtualenvs/crate-installer

INSTALLER_HOME="$( cd "$( dirname "$0" )" && pwd )"

# -----------------------------------------------------------------------------
# System Python to use
# -----------------------------------------------------------------------------

CRATE_INSTALLER_PYTHON=${CRATE_INSTALLER_PYTHON:-python3}

# -----------------------------------------------------------------------------
# Fetching CRATE and boostrap the installer
# -----------------------------------------------------------------------------

# Create virtual environment
if [ ! -d "${CRATE_INSTALLER_VENV}" ]; then
    # TODO: Option to rebuild venv
    "${CRATE_INSTALLER_PYTHON}" -m venv "${CRATE_INSTALLER_VENV}"
fi

# Activate virtual environment
source "${CRATE_INSTALLER_VENV}/bin/activate"

# Check virtual environment
PYTHON_VERSION_OK=$(python -c 'import sys; print(sys.version_info.major >=3 and sys.version_info.minor >= 7)')
if [ "${PYTHON_VERSION_OK}" == "False" ]; then
    python --version
    echo "You need at least Python 3.7 to run the installer."
    exit 1
fi

# Install a few packages
python -m pip install -U pip setuptools
python -m pip install -r "${INSTALLER_HOME}/installer-requirements.txt"

# Run the Python installer
python "${INSTALLER_HOME}/installer.py"
