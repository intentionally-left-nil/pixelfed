ref ?= $(shell cat pixelfed_ref.txt)

.PHONY: test publish_release docker-build

test:
	@echo "Testing patches..."
	git clone --branch $(ref) --depth 1 https://github.com/pixelfed/pixelfed.git
	cd pixelfed; \
	for patch in ../patches/*.patch; do \
		echo "Applying $$patch"; \
		git apply "$$patch" || { echo "Failed to apply $$patch"; exit 1; }; \
	done; \
	cd ..; \
		rm -rf pixelfed; \
		echo "Patches applied successfully"

build:
	@set -e; \
	tmpdir=$$(mktemp -d); \
	trap 'rm -rf "$$tmpdir"' EXIT; \
	git clone --branch $(ref) --depth 1 https://github.com/pixelfed/pixelfed.git "$$tmpdir/pixelfed"; \
	for patch in "$(CURDIR)"/patches/*.patch; do \
		[ -f "$$patch" ] || continue; \
		git -C "$$tmpdir/pixelfed" apply "$$patch"; \
	done; \
	sudo docker build \
		--build-arg RUNTIME_UID=1000 \
		--build-arg RUNTIME_GID=1000 \
		-t pixelfed:local \
		"$$tmpdir/pixelfed"
