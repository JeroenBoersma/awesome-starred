
GO_BASE_IMAGE = docker.io/library/golang:alpine
STARRED_REPO = github.com/juev/starred@latest
STARRED_IMAGE = github_starred

GITHUB_TOKEN ?= 
GITHUB_USERNAME ?= 

CONTAINER_EXECUTABLE = podman
CONTAINER_COMMAND = 
CONTAINER_ARGUMENTS = 

.PHONY: all
all:

containerize:
	$(CONTAINER_EXECUTABLE) $(CONTAINER_COMMAND) $(CONTAINER_ARGUMENTS)


export GITHUB_TOKEN


README.md: CONTAINER_COMMAND = run \
		--rm -it \
		-v "$(PWD)":"$(PWD)" \
		--workdir="$(PWD)" \
		-e GITHUB_TOKEN \
		"$(STARRED_IMAGE)"
README.md: CONTAINER_ARGUMENTS = -u "$(GITHUB_USERNAME)" \
		--sort
README.md: .envrc
#	$(MAKE) build
	$(MAKE) containerize CONTAINER_COMMAND='$(CONTAINER_COMMAND)' CONTAINER_ARGUMENTS='$(CONTAINER_ARGUMENTS)' | tee "$@"

.PHONY: build
build: CONTAINER_COMMAND = build -t "$(STARRED_IMAGE)" .
build: Dockerfile
	$(MAKE) containerize CONTAINER_COMMAND='$(CONTAINER_COMMAND)' CONTAINER_ARGUMENTS='$(CONTAINER_ARGUMENTS)' 


export CONTAINERFILE_CONTENTS

Dockerfile:
	echo "$${CONTAINERFILE_CONTENTS}" > $@


export ENVRC_CONTENTS

.envrc: Makefile
	echo "$${ENVRC_CONTENTS}" > $@


define CONTAINERFILE_CONTENTS
FROM $(GO_BASE_IMAGE)

RUN go install $(STARRED_REPO)

ENTRYPOINT ["/go/bin/starred"]

endef

define ENVRC_CONTENTS

source_up_if_exists

export GITHUB_TOKEN="$(GITHUB_TOKEN)"
export GITHUB_USERNAME="$(GITHUB_USERNAME)"

endef

