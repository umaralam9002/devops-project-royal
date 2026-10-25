OUT_DIR=out

check:
	@echo "check: 3 source file(s) in src"

build: check
	mkdir -p $(OUT_DIR)
	npx devops-build src/greeting.md $(OUT_DIR)/greeting.html
	npx devops-build src/notes.md $(OUT_DIR)/notes.html
	npx devops-build src/services.md $(OUT_DIR)/services.html

test: build
	npm test

deps:
	npm ci

package: test
	npm pack

clean:
	rm -rf $(OUT_DIR) *.tgz

ci: clean deps build test package
