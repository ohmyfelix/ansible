# AGENTS.md

## Project

This repository builds `dockette/ansible`, a small Docker image for running Ansible commands from a mounted project directory.

## Image Layout

- Published image is `dockette/ansible`.
- Supported tags are `debian-11` and `debian-10`.
- Build contexts are `debian-11/` and `debian-10/`.
- `debian-11/Dockerfile` starts from `dockette/debian:bullseye-slim`.
- `debian-10/Dockerfile` starts from `dockette/debian:buster-slim`.
- Both images install `gnupg2`, Python 3, pip, curl, wget, Ansible from the Ansible PPA, and `ansible-lint[community,yamllint]` through pip.
- Both images default to `CMD ["/bin/bash"]`.

## Makefile

- Default image is `${DOCKER_IMAGE}:${DOCKER_TAG}`, where `DOCKER_IMAGE?=dockette/ansible` and `DOCKER_TAG?=debian-11`.
- Default build context is `DOCKER_CONTEXT?=debian-11`.
- Use `make build` for the default local image build.
- Use `make test` after building the selected tag; it checks `ansible --version` and conditionally checks `ansible-lint --version`.
- Use `make run` for an interactive shell with the current working directory mounted at `/srv`.
- When changing variants, override `DOCKER_TAG` and `DOCKER_CONTEXT` together, for example `make build test DOCKER_TAG=debian-10 DOCKER_CONTEXT=debian-10`.

## CI

- `.github/workflows/docker.yml` tests and builds both `debian-11` and `debian-10`.
- The test job builds each matrix image locally with `docker/build-push-action` and `load: true`.
- The test job must pass `DOCKER_IMAGE=dockette/ansible` and `DOCKER_TAG=${{ matrix.image }}` to `make test` so the Makefile checks the matrix image.
- The build job delegates publishing to the shared `dockette/.github/.github/workflows/docker.yml@master` workflow.
- The build job publishes multi-platform images for `linux/amd64` and `linux/arm64` only on `master`.
- The docs job updates the Docker Hub description from `README.md` after successful builds on `master`.

## Validation

- Run `make -n build test run` before committing Makefile changes.
- Run `make build test DOCKER_TAG=debian-11 DOCKER_CONTEXT=debian-11` for the default image when Docker is available.
- Run `make build test DOCKER_TAG=debian-10 DOCKER_CONTEXT=debian-10` when touching the Debian 10 context.
- Run `git diff --check` before committing.
- Keep `CLAUDE.md` as exactly `@AGENTS.md`.

## Contribution Notes

- Keep `README.md`, `Makefile`, `.github/workflows/docker.yml`, and both Dockerfiles aligned when adding, removing, or renaming tags.
- Prefer `DOCKER_*` Makefile variables for Docker image, tag, context, and platform settings.
- Place `.PHONY: <target>` directly above each Makefile target.
- Do not add Compose-specific guidance; this repo has no compose stack.
- Avoid broad package upgrades unless you verify both Debian contexts still build.
- Be careful with the legacy Ansible PPA and `apt-key` usage; changing either can break old Debian contexts.
- Keep README badges and the Maintenance section consistent with the Dockette image baseline.
