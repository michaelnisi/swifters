#
# Makefile - Build Swifters
#

MAKEFLAGS += --warn-undefined-variables

XCODEBUILD := xcodebuild

NAME := Swifters
WORKSPACE := $(shell echo $(workspace))

CONFIG := ./apollo.config.js

all: $(CONFIG)

deps:
	mkdir deps
	./scripts/setup

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
	jazzy -x -workspace,$(WORKSPACE),-scheme,$(NAME) \
		--min-acl internal \
		--author "Michael Nisi" \
		--author_url "https://troubled.pro"
else
	@echo "Which workspace?"
endif

.PHONY: clean
clean:
	rm $(CONFIG)
	rm -rf deps docs
