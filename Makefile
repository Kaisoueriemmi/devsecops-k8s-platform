FLOCI_ENDPOINT ?= http://localhost:4566
.PHONY: help floci-check
help:
	@echo "Cibles : floci-check (up/down arrivent en v2)"
floci-check:
	@bash scripts/floci-check.sh $(FLOCI_ENDPOINT)
