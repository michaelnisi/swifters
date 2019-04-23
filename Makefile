#
# Makefile - Build Swifters
#

WORKSPACE := $(shell echo $(workspace))
SCHEME := Swifters

MAKEFLAGS += --warn-undefined-variables

NPX := npx
XCODEBUILD := xcodebuild

NAME := Swifters

API := https://api.github.com/graphql

CONFIG := ./Swifters/config.json
SCHEMA := ./Swifters/schema.json

all: $(SCHEMA) $(CONFIG) build

deps:
	mkdir deps
	./scripts/setup

$(SCHEMA):
	npx apollo schema:download $(SCHEMA) --endpoint=$(API) \
		--header="Authorization: Bearer $(GITHUB_TOKEN)"

.PHONY: schema
schema: $(SCHEMA)

$(CONFIG):
	./scripts/configure

.PHONY: config
config: $(CONFIG)

.PHONY: build
build: deps $(CONFIG)
	$(XCODEBUILD) build -workspace $(NAME).xcworkspace \
		-configuration Debug -scheme $(NAME)

docs:
ifdef WORKSPACE
	jazzy -x -workspace,$(WORKSPACE),-scheme,$(SCHEME) \
		--min-acl internal \
		--author "Michael Nisi" \
		--author_url https://troubled.pro
else
	@echo "Which workspace?"
endif

.PHONY: clean
clean:
	rm $(CONFIG)
	rm $(SCHEMA)
	rm -rf deps docs
