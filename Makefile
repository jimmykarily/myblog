# Build and preview the site in a container, so a machine needs nothing
# installed beyond docker or podman. No local Ruby, no local gems.
#
#   make serve    build, watch for changes and serve on http://localhost:4000
#   make build    write the site to _site and exit
#   make shell    a shell inside the container, for debugging
#   make clean    remove build output
#
# Override any variable on the command line, for example:
#   make serve PORT=8080
#   make build IMAGE=ruby:3.3

ENGINE ?= $(shell command -v podman 2>/dev/null || command -v docker 2>/dev/null)
IMAGE  ?= ruby:3.2
PORT   ?= 4000
LIVERELOAD_PORT ?= 35729

# Extra flags passed through to jekyll, for example JEKYLL_FLAGS=--drafts.
# On filesystems where inotify does not reach the container (some network
# mounts, some macOS setups) add --force_polling here.
JEKYLL_FLAGS ?=

# Interactive by default so Ctrl-C stops the server. Set TTY= when running
# from a script or CI, where there is no terminal attached.
TTY ?= -it

# Gems live inside the repo rather than in a container volume, so they survive
# restarts and stay owned by the current user instead of root. Gitignored.
BUNDLE_DIR := .bundle

RUN = $(ENGINE) run --rm $(TTY) \
	--user $(shell id -u):$(shell id -g) \
	-v "$(CURDIR)":/srv/jekyll \
	-w /srv/jekyll \
	-e HOME=/tmp \
	-e BUNDLE_PATH=/srv/jekyll/$(BUNDLE_DIR)/vendor \
	-e BUNDLE_APP_CONFIG=/srv/jekyll/$(BUNDLE_DIR)

.PHONY: help serve build install update shell clean clean-gems check-engine

help:
	@echo "make serve    serve on http://localhost:$(PORT) and rebuild on change"
	@echo "make build    write the site to _site"
	@echo "make install  install the gems into $(BUNDLE_DIR)"
	@echo "make update   update the gems and Gemfile.lock"
	@echo "make shell    open a shell in the container"
	@echo "make clean    remove _site and the Jekyll cache"
	@echo "make clean-gems  remove the cached gems as well"

check-engine:
ifeq ($(ENGINE),)
	@echo "No container engine found. Install docker or podman, or pass ENGINE=/path/to/engine." >&2
	@exit 1
endif

install: check-engine
	$(RUN) $(IMAGE) bundle install

# Rebuilds on change. --host 0.0.0.0 is required for the port to be reachable
# from outside the container.
serve: install
	$(RUN) -p $(PORT):4000 -p $(LIVERELOAD_PORT):35729 $(IMAGE) \
		bundle exec jekyll serve --host 0.0.0.0 --livereload $(JEKYLL_FLAGS)

build: install
	$(RUN) $(IMAGE) bundle exec jekyll build $(JEKYLL_FLAGS)

update: check-engine
	$(RUN) $(IMAGE) bundle update

shell: check-engine
	$(RUN) $(IMAGE) bash

clean:
	rm -rf _site .jekyll-cache

clean-gems: clean
	rm -rf $(BUNDLE_DIR)
