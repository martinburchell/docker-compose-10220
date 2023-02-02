# docker/dockerfiles/crate.Dockerfile
#
# Docker image that provides:
#
# - CRATE
# - database drivers
# - third-party text extraction tools
# - GATE
#
# Directory structure in container:
#
#   /crate              All CRATE code/binaries.
#       /cfg            Config files are mounted here.
#       /gate           GATE program
#       /src            Source code for CRATE.
#       /venv           Python 3 virtual environment.
#           /bin        Main CRATE executables live here.


# -----------------------------------------------------------------------------
# FROM: Base image
# -----------------------------------------------------------------------------

FROM python:3.8-slim-buster
# This is a version of Debian 10 (see "cat /etc/debian_version").


# -----------------------------------------------------------------------------
# LABEL: metadata
# -----------------------------------------------------------------------------
# https://docs.docker.com/engine/reference/builder/#label


LABEL description="See https://crateanon.readthedocs.io/"
LABEL maintainer="Rudolf Cardinal <rudolf@pobox.com>"


# -----------------------------------------------------------------------------
# Permissions
# -----------------------------------------------------------------------------
# https://vsupalov.com/docker-shared-permissions/

ARG USER_ID
RUN adduser --disabled-password --gecos '' --uid $USER_ID crate


# -----------------------------------------------------------------------------
# ADD: files to copy
# -----------------------------------------------------------------------------
# - Syntax: ADD <host_file_spec> <container_dest_dir>
# - The host file spec is relative to the context (and can't go "above" it).
# - This docker file lives in the "docker/dockerfiles" directory within
#   the CRATE source, so we expect Docker to be told (externally -- see e.g.
#   the Docker Compose file) that the context is a higher directory.
#   That is the directory containing "setup.py" and therefore the installation
#   directory for our Python package.
# - So in short, here we refer to the context as ".".

ADD . /crate/src


# -----------------------------------------------------------------------------
# COPY: can copy from other Docker images
# -----------------------------------------------------------------------------
# - https://docs.docker.com/engine/reference/builder/#copy
# - https://stackoverflow.com/questions/24958140/what-is-the-difference-between-the-copy-and-add-commands-in-a-dockerfile


# -----------------------------------------------------------------------------
# WORKDIR: Set working directory on container.
# -----------------------------------------------------------------------------
# Shouldn't really be necessary.

WORKDIR /crate


# -----------------------------------------------------------------------------
# RUN: run a command.
# -----------------------------------------------------------------------------
# - mmh3 needs g++ as well as gcc.
#
# - pdftotext is part of poppler-utils.
#
# - unixodbc-dev is required for the Python pyodbc package (or: missing sql.h).
#
# - Java for GATE (but default-jdk didn't work)...
#   ... in fact the problem is that you need
#   mkdir -p /usr/share/man/man1 /usr/share/man/man2
#   https://stackoverflow.com/questions/61815233/install-java-runtime-in-debian-based-docker-image
#
# - GATE installation is via izpack:
#   https://github.com/GateNLP/gate-core/blob/master/distro/src/main/izpack/install.xml
#   https://izpack.atlassian.net/wiki/spaces/IZPACK/pages/491674/Installer+Runtime+Options
#   https://izpack.atlassian.net/wiki/spaces/IZPACK/pages/42270722/Mixed+Installation+Mode+Using+Variable+Defaults
#   https://stackoverflow.com/questions/6519571/izpack-installer-options-auto
#   https://groups.google.com/forum/#!topic/izpack-user/ecp1U8CAOT8
#   ... the XML file determines the installation path.
#
# - Microsoft ODBC driver for SQL Server (Linux):
#   https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server
#   - gnupg2 is required for the curl step.
#   - mssql-tools brings sqlcmd:
#     https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility
#
# - Testing KCL pharmacotherapy app:
#
#   export NLPPROGDIR=/crate/venv/lib/python3.8/site-packages/crate_anon/nlp_manager/compiled_nlp_classes/
#   export GATEDIR=/crate/gate
#   export GATE_PHARMACOTHERAPY_DIR=/crate/brc-gate-pharmacotherapy
#   export PLUGINFILE=/crate/src/crate_anon/nlp_manager/specimen_gate_plugin_file.ini
#   export TERMINATOR=END
#   java -classpath "${NLPPROGDIR}:${GATEDIR}/bin/gate.jar:${GATEDIR}/lib/*" -Dgate.home="${GATEDIR}" CrateGatePipeline --gate_app "${GATE_PHARMACOTHERAPY_DIR}/application.xgapp" --include_set Output --annotation Prescription --input_terminator "${TERMINATOR}" --output_terminator "${TERMINATOR}" --suppress_gate_stdout --pluginfile "${PLUGINFILE}"
#
# - For KConnect/Bio-YODIE:

#   - ant is required by plugins/compilePlugins.sh, from Bio-YODIE.
#   - see https://github.com/GateNLP/bio-yodie-resource-prep
#   - UMLS: separate licensing

RUN echo "===============================================================================" \
    && echo "CRATE" \
    && echo "===============================================================================" \
    && echo "- Creating Python 3 virtual environment..." \
    && python3 -m venv /crate/venv \
    && echo "- Done."


# -----------------------------------------------------------------------------
# EXPOSE: expose a port.
# -----------------------------------------------------------------------------
# We'll do this via docker-compose instead.


# -----------------------------------------------------------------------------
# CMD: run the foreground task whose lifetime determines the container
# lifetime.
# -----------------------------------------------------------------------------
# Note: can be (and is) overridden by the "command" option in a docker-compose
# file.

# CMD ["/bin/bash"]

USER crate
