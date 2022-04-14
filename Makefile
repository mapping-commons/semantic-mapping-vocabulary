ONTBASE=http://w3id.org/omapv
ROBOT=robot

all: omapv.owl

omapv.owl: omapv.tsv
	$(ROBOT) template --template $< --prefix "OMAPV: http://w3id.org/omapv/vocab/" \
		annotate --ontology-iri $(ONTBASE)/vocab -o $@
