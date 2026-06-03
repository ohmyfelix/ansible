DOCKER_IMAGE?=dockette/ansible
DOCKER_TAG?=debian-11
DOCKER_CONTEXT?=debian-11


.PHONY: build
build:
	docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_CONTEXT}

.PHONY: test
test:
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} ansible --version
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} sh -lc 'if command -v ansible-lint >/dev/null 2>&1; then ansible-lint --version; fi'

.PHONY: run
run:
	docker run --rm -it -v "$${PWD}:/srv" ${DOCKER_IMAGE}:${DOCKER_TAG} bash
