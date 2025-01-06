ONTBASE=http://w3id.org/semapv
ROBOT=robot -vvv
DATE ?= $(shell date +%Y-%m-%d)

all: semapv.owl docs/index.html

semapv-terms.owl: semapv-terms.tsv
	$(ROBOT) template --template $< --prefix "skos: http://www.w3.org/2004/02/skos/core#" --prefix "semapv: https://w3id.org/semapv/vocab/" \
		annotate --ontology-iri $(ONTBASE)/vocab/$@ --version-iri $(ONTBASE)/vocab/releases/$(DATE)/$@ -o $@

semapv-properties.owl: semapv-properties.tsv
	$(ROBOT) template --template $< --prefix "skos: http://www.w3.org/2004/02/skos/core#" --prefix "semapv: https://w3id.org/semapv/vocab/" \
		annotate --ontology-iri $(ONTBASE)/vocab/$@ --version-iri $(ONTBASE)/vocab/releases/$(DATE)/$@ -o $@

SEMAPV_TERMS_URL=https://docs.google.com/spreadsheets/d/e/2PACX-1vQS6dVyRqEdXCtimXw1nxX77NCmJCfm_2sOL0eCkt_7MlTt8wCNgE8iw9pLACPIuwZDvu64WtsqtREQ/pub?gid=0&single=true&output=tsv

semapv-terms.tsv:
	wget "$(SEMAPV_TERMS_URL)" -O $@

semapv.owl: semapv-metadata.owl semapv-terms.owl semapv-properties.owl context.jsonld
	$(ROBOT) merge -i semapv-metadata.owl --add-prefixes context.jsonld -i semapv-terms.owl -i semapv-properties.owl \
	annotate --ontology-iri $(ONTBASE)/vocab/$@ --version-iri $(ONTBASE)/vocab/releases/$(DATE)/$@ \
	merge --add-prefixes context.jsonld -o $@

docs/index.html: semapv.owl
	pip install pylode --break-system-packages
	python -m pylode $< -o $@

.PHONY: help
help:
	@echo "$$data"
	@echo "----------------------------------------"
	@echo "	Command reference: semapv"
	@echo "----------------------------------------"
	@echo "all: build docs and semapv vocabulary"