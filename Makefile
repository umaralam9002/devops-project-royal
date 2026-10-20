SRC_DIR := src
OUT_DIR := out

SOURCES := $(wildcard $(SRC_DIR)/*.md)
OUTPUTS := $(patsubst $(SRC_DIR)/%.md,$(OUT_DIR)/%.html,$(SOURCES))

.PHONY: all check build test clean ci deps package

all: test

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

node_modules: package-lock.json
	npm ci
	@touch node_modules

deps: node_modules

$(OUT_DIR)/%.html: $(SRC_DIR)/%.md package-lock.json | $(OUT_DIR) node_modules
	@echo "  BUILD $< -> $@"
	@npm run --silent build -- $< $@

check:
	@if [ ! -d "$(SRC_DIR)" ]; then \
		echo "CHECK FAILED: missing $(SRC_DIR)"; \
		exit 1; \
	elif [ "$(words $(SOURCES))" -eq 0 ]; then \
		echo "CHECK FAILED: no .md files found in $(SRC_DIR)"; \
		exit 1; \
	else \
		echo "CHECK PASSED: $(words $(SOURCES)) source(s) found"; \
	fi

build: $(OUTPUTS)

test: build
	@npm test --silent

package: test
	npm pack

clean:
	rm -rf $(OUT_DIR) *.tgz

ci: clean deps check test package

