#!/usr/bin/env python

"""
installer/installer.py

===============================================================================

    Copyright (C) 2015, University of Cambridge, Department of Psychiatry.
    Created by Rudolf Cardinal (rnc1001@cam.ac.uk).

    This file is part of CRATE.

    CRATE is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    CRATE is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with CRATE. If not, see <https://www.gnu.org/licenses/>.

===============================================================================

Installs CRATE running under Docker with demonstration databases. Bootstrapped
from ``installer.sh``. Note that the full CRATE Python environment is NOT
available.

"""

import os

from python_on_whales import docker

# Python Prompt Toolkit has basic support for text entry / yes-no / alert
# dialogs but unfortunately there are a couple of features lacking:
#
# Completion does not display:
# https://github.com/prompt-toolkit/python-prompt-toolkit/issues/715
#
# No way of specifying a default:
# https://github.com/prompt-toolkit/python-prompt-toolkit/issues/1544
#
# So for now, just use basic prompts.
#
# An alternative library is Urwid (https://urwid.org/) but that leaves a
# lot of work for the programmer (See file browser example:
# https://github.com/urwid/urwid/blob/master/examples/browse.py


# =============================================================================
# Constants
# =============================================================================

EXIT_FAILURE = 1


class HostPath:
    """
    Directories and filenames as seen from the host OS.
    """

    INSTALLER_DIR = os.path.dirname(os.path.realpath(__file__))
    PROJECT_ROOT = os.path.join(INSTALLER_DIR, "..")
    DOCKER_DIR = os.path.join(PROJECT_ROOT, "docker")
    DOCKERFILES_DIR = os.path.join(DOCKER_DIR, "dockerfiles")


class DockerPath:
    """
    Directories and filenames as seen from the Docker containers.
    """

    BASH = "/bin/bash"


class DockerComposeServices:
    """
    Subset of services named in ``docker/dockerfiles/docker-compose.yaml``.
    """

    CRATE_WORKERS = "crate_workers"


# =============================================================================
# Installer base class
# =============================================================================


class Installer:
    # -------------------------------------------------------------------------
    # Commands
    # -------------------------------------------------------------------------

    def install(self) -> None:
        self.run_crate_command("ls /crate/venv/")

    def run_crate_command(self, crate_command: str) -> None:
        self.run_bash_command_inside_docker(
            f"source /crate/venv/bin/activate; {crate_command}"
        )

    # -------------------------------------------------------------------------
    # Shell handling
    # -------------------------------------------------------------------------

    @staticmethod
    def run_bash_command_inside_docker(bash_command: str) -> None:
        os.chdir(HostPath.DOCKERFILES_DIR)
        docker.compose.run(
            DockerComposeServices.CRATE_WORKERS,
            remove=True,
            command=[DockerPath.BASH, "-c", bash_command],
        )


# =============================================================================
# Command-line entry point
# =============================================================================


def main() -> None:
    Installer().install()


if __name__ == "__main__":
    main()
