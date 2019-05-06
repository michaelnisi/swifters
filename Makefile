#
# Makefile - Build Swifters
#

MAKEFLAGS += --warn-undefined-variables

XCODEBUILD := xcodebuild

NAME := Swifters
WORKSPACE := $(shell echo $(workspace))

CONFIG := ./apollo.config.js
JSON := ./Swifters/github/apollo.config.json

all: deps $(JSON)

deps:
	mkdir deps
	./scripts/setup

$(CONFIG):
	./scripts/configure

config: $(CONFIG)

$(JSON): $(CONFIG)
	node $(CONFIG) > $(JSON)

json: $(JSON)

.PHONY: build
build: deps $(CONFIG)
	$(XCODEBUILD) build -workspace $(NAME).xcworkspace \
		-configuration Debug -scheme $(NAME)

docs:
ifdef WORKSPACE
	jazzy -x -workspace,$(WORKSPACE),-scheme,$(NAME) \
		--min-acl internal \
		--author "Michael Nisi" \
		--author_url "https://troubled.pro"
else
	@echo "Which workspace?"
endif

.PHONY: clean
clean:
	rm $(CONFIG) $(JSON)
	rm -rf deps docs
