# AGENTS.md

## Purpose

This repository builds `dockette/ansible`, a small Debian-based Docker image family for running Ansible and ansible-lint from a mounted project directory. It is an image repository only: there is no application code, Compose setup, package manifest, or test suite outside Docker image build and smoke-test commands.

## Image Matrix

- Published image: `dockette/ansible`.
- Tags and build contexts: `debian-11`, `debian-10`.
- Default local target: `DOCKER_TAG=debian-11` with `DOCKER_CONTEXT=debian-11`.
- `debian-11/Dockerfile` starts from `dockette/debian:bullseye-slim`.
- `debian-10/Dockerfile` starts from `dockette/debian:buster-slim`.
- README usage mounts the current directory to `/srv` and opens Bash in `dockette/ansible:debian-11`.

## Dockerfile Layout

- Each supported tag has its own top-level directory containing one `Dockerfile`.
- Both Dockerfiles currently share the same install flow: update Debian packages, install `gnupg2`, Python 3, pip, curl, and wget, add the Ansible Ubuntu Trusty PPA, install `ansible`, install `ansible-lint[community,yamllint]` with pip, then use Bash as the default command.
- Keep Dockerfile changes mirrored between variants unless a Debian-version-specific difference is intentional and documented.
- The cleanup command is currently `rm -rf /var/cache/apk/*` even though these are Debian images. Do not expand or normalize cleanup behavior without checking the image build impact.

## Commands

- `make build` builds `${DOCKER_IMAGE}:${DOCKER_TAG}` from `${DOCKER_CONTEXT}`.
- `make test` runs `ansible --version` and runs `ansible-lint --version` only if the command is available.
- `make run` starts an interactive Bash shell with the current directory mounted to `/srv`.
- Test another variant with matching overrides, for example `make build test DOCKER_TAG=debian-10 DOCKER_CONTEXT=debian-10`.
- Use `make -n build test run` to inspect the generated Docker commands without building or running containers.

## Makefile Variables

- `DOCKER_IMAGE` defaults to `dockette/ansible`.
- `DOCKER_TAG` defaults to `debian-11`.
- `DOCKER_CONTEXT` defaults to `debian-11`.
- Keep tag and context values aligned unless deliberately testing a cross-context build.
- Prefer `DOCKER_*` variable names for Docker-related Makefile changes.

## CI Notes

- `.github/workflows/docker.yml` runs on `workflow_dispatch`, pushes to `master`, and a weekly Monday schedule.
- The `test` job builds each matrix image with `docker/build-push-action@v6`, loads it locally, tags it as `dockette/ansible:${{ matrix.image }}`, then calls `make test`.
- The `build` job delegates publishing to `dockette/.github/.github/workflows/docker.yml@master` for `linux/amd64,linux/arm64` and pushes only on `master`.
- The `docs` job updates the Docker Hub description from `README.md` on `master` after build completion.
- The workflow passes `DOCKER_IMAGE=dockette/ansible` and `DOCKER_TAG=${{ matrix.image }}` to `make test`; keep that aligned with Makefile variable names so CI tests the matrix tag instead of the defaults.

## Validation

- Run `git diff --check` before handing off changes.
- Run `make -n build test run` for Makefile command validation that does not require Docker.
- For Docker-affecting changes, build and test every supported variant with matching `DOCKER_TAG` and `DOCKER_CONTEXT` overrides when feasible.
- Verify `CLAUDE.md` remains exactly `@AGENTS.md`.
- Verify intended changes are limited to the requested files.

## Caveats

- Do not edit `CLAUDE.md` beyond keeping it as the exact one-line pointer `@AGENTS.md`.
- Do not add generic Dockette boilerplate; this repo has only the two Ansible image variants listed above.
- Keep `README.md`, `Makefile`, `.github/workflows/docker.yml`, and both Dockerfiles in sync when changing tags, contexts, dependencies, or command behavior.
- Avoid unrelated formatting churn in the HTML-heavy README and the minimal Dockerfiles.
- Treat the Ansible PPA, `apt-key`, and Debian base-image choices as existing behavior, not incidental style issues, unless the task is specifically to modernize them.
