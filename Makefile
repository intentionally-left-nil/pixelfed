.PHONY: test publish_release

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
