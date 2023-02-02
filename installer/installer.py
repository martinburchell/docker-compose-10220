import os

from python_on_whales import docker


class HostPath:
    """
    Directories and filenames as seen from the host OS.
    """
    INSTALLER_DIR = os.path.dirname(os.path.realpath(__file__))
    PROJECT_ROOT = INSTALLER_DIR
    DOCKERFILES_DIR = PROJECT_ROOT


class DockerPath:
    """
    Directories and filenames as seen from the Docker containers.
    """

    BASH = "/bin/bash"
    ROOT_DIR = "/test"


class DockerComposeServices:
    """
    Subset of services named in ``docker-compose.yaml``.
    """

    SERVER = "server"


def main() -> None:
    os.environ["INSTALL_USER_ID"] = str(os.geteuid())
    run_script_in_container("python --version")


def run_script_in_container(command: str) -> None:
    run_bash_command_in_container(
        f"source /test/venv/bin/activate; {command}"
    )


def run_bash_command_in_container(command: str) -> None:
    os.chdir(HostPath.DOCKERFILES_DIR)
    docker.compose.run(
        DockerComposeServices.SERVER,
        remove=True,
        command=[DockerPath.BASH, "-c", command],
    )


if __name__ == "__main__":
    main()
