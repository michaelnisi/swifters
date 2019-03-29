#
# Makefile - Build Swifters
#

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
	npx apollo schema:download --endpoint=$(API) \
		--header="Authorization: Bearer $(GITHUB_TOKEN)"
	mv ./schema.json $(SCHEMA)

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

.PHONY: clean
clean:
	rm $(CONFIG)
	rm $(SCHEMA)
	rm -rf deps
