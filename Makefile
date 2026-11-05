SRC_DIR := src
OUT_DIR := out
SOURCES := $(wildcard $(SRC_DIR)/*.md)
OUTPUTS := $(patsubst $(SRC_DIR)/%.md,$(OUT_DIR)/%.html,$(SOURCES))

.PHONY: all check build test clean ci deps package lint

all: test

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

node_modules: package-lock.json
	npm ci
	@touch node_modules

deps: node_modules

$(OUT_DIR)/%.html: $(SRC_DIR)/%.md package-lock.json | $(OUT_DIR) node_modules
	@echo " BUILD $< -> $@"
	@npm run build --silent -- $< $@

check:
	@if [ -z "$(SOURCES)" ]; then \
		echo "CHECK FAILED: no .md files found in $(SRC_DIR)"; \
		exit 1; \
	fi
	@echo "CHECK PASSED: found $(words $(SOURCES)) source file(s)"

build: $(OUTPUTS)

lint: node_modules ## static analysis: seconds, so it runs first
	npm run --silent lint

test: build
	@node --test

coverage: build ## the tests again, writing coverage/lcov.info for SonarQube
	@mkdir -p coverage
	node --test --experimental-test-coverage \
	--test-reporter spec --test-reporter-destination=stdout \
	--test-reporter=lcov --test-reporter-destination=coverage/lcov.info

package: test
	npm pack

clean:
	@rm -rf $(OUT_DIR) coverage *.tgz

ci: clean deps check lint test package ## everything, in pipeline order
