# AGENTS.md

## Project

Dockette Ansible provides Debian-based Docker images with Ansible and optional ansible-lint tooling for running playbooks from a mounted working directory.

## Images

- Image name is `dockette/ansible`.
- Supported tags and build contexts are `debian-11` and `debian-10`.
- Makefile defaults to `DOCKER_TAG=debian-11` and `DOCKER_CONTEXT=debian-11`.
- `debian-11/Dockerfile` uses `dockette/debian:bullseye-slim`.
- `debian-10/Dockerfile` uses `dockette/debian:buster-slim`.
- Both Dockerfiles install Python 3, Ansible from the Ansible PPA, and `ansible-lint[community,yamllint]` via pip.

## Commands

- `make build` builds `${DOCKER_IMAGE}:${DOCKER_TAG}` from `${DOCKER_CONTEXT}`.
- `make test` runs `ansible --version` and runs `ansible-lint --version` only if the command is available.
- `make run` starts an interactive Bash shell with the current directory mounted to `/srv`.
- Override `DOCKER_TAG` and `DOCKER_CONTEXT` together when testing the non-default Debian variant.

## Runtime Notes

- No Compose file is present; local runtime is direct `docker run`.
- Runtime mount is `-v "$${PWD}:/srv"`; commands inside the container should use `/srv` as the project directory.
- GitHub Actions tests and builds both Debian variants for `linux/amd64` and `linux/arm64` using each tag as its build context.
- The workflow currently passes `IMAGE=...` to `make test`, but the Makefile uses `DOCKER_IMAGE` and `DOCKER_TAG` variables.

## Guidelines

- Keep `README.md`, `Makefile`, both Debian Dockerfiles, and `.github/workflows/docker.yml` aligned when changing tags or dependencies.
- Prefer `DOCKER_*` names for Docker-related Makefile variables.
- Place `.PHONY: <target>` directly above each Makefile target.
- Keep README badges and maintenance sections consistent with other Dockette image repos.
- Do not introduce unrelated formatting or structural changes.
