### Configuration
#
# These are standard options to make Make sane:
# <http://clarkgrubb.com/makefile-style-guide#toc2>

MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:
.SECONDARY:


### General Tasks

.PHONY: all
all:

build:
	mkdir -p $@

.PHONY: clean
clean:
	rm -rf build


### Test, Lint, Format

PYTHON_FILES := src tests

.PHONY: test
test:
	pytest tests

.PHONY: lint
lint:
	flake8 --max-line-length 100 --ignore E203,W503 $(PYTHON_FILES)
	black --line-length 100 --quiet --check $(PYTHON_FILES)

.PHONY: format
format:
	black --line-length 100 $(PYTHON_FILES)
