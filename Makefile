IMAGE ?= dockette/ansible:debian-11
CONTEXT ?= debian-11

.PHONY: build test run

build:
	docker build -t $(IMAGE) $(CONTEXT)

test:
	docker run --rm $(IMAGE) sh -lc 'ansible --version && if command -v ansible-lint >/dev/null 2>&1; then ansible-lint --version; fi'

run:
	docker run --rm -it -v "$(PWD):/srv" $(IMAGE) bash
