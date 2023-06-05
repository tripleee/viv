VERSION ?= $(shell git describe --tags --always --dirty=-dev | sed 's/^v//g')
PREFIX ?= ~/bin

lint: ## run pre-commit hooks
	pdm run pre-commit run --all || pdm run pre-commit run --all

types: ## run mypy
	mypy src/viv

bump: ## update version and tag commit
	@echo "bumping to version => $(VERSION)"
	@sed -i 's/__version__ = ".*"/__version__ = "$(VERSION)"/g' src/viv/viv.py
	@git add src/viv/viv.py && git commit -m "chore: bump version" --no-verify
	@git tag v$(VERSION)
	@git tag -d latest || true
	@git tag latest

venv: ## generate environment
	pdm install

.PHONY: dev-install
dev-install:
	ln -sf $(PWD)/srv/viv/viv.py ~/.local/share/viv/viv.py

docs: docs/index.md docs/viv.py ## build docs
	mkdocs build

docs/viv.py: src/viv/viv.py
	cp $< $@

docs/index.md: README.md
	cp $< $@

examples/black: .FORCE
	rm -f $@
	viv shim black -y -s -f -o $@

clean: ## remove build artifacts
	rm -rf {build,dist}

EXAMPLES = cli.py sys_path.py exe_specific.py frozen_import.py named_env.py scrape.py
generate-example-vivens: ##
	for f in $(EXAMPLES); \
		do python examples/$$f; done


.FORCE:
.PHONY: .FORCE
-include .task.cfg.mk
