build:
	docker compose build --progress plain

shell:
	docker run -it --rm fhir-anonymizer /bin/bash

.PHONY: run
run: build
	rm -rf ./data/output/* && \
	docker compose run --rm --name fhir-anonymizer fhir-anonymizer anonymize -i /data/input/ -o /data/output/ -c /data/config/config.json -v
