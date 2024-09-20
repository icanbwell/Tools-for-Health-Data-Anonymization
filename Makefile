build:
	docker compose build --progress plain

shell:
	docker run -it --rm fhir-anonymizer /bin/bash

# config file format: https://github.com/microsoft/Tools-for-Health-Data-Anonymization/blob/master/docs/FHIR-anonymization.md#fhir-path-rules

.PHONY: run
run:
	rm -rf ./data/output/* && \
	docker compose run --rm --name fhir-anonymizer fhir-anonymizer anonymize -r -i /data/input/bailey/ -o /data/output/bailey/ -c /data/config/config.json -v && \
	make find_text

.PHONY: find_text
find_text:
	python3 find_text_in_files.py data/output/bailey bailey
