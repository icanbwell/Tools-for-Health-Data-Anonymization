build:
	docker compose build --progress plain

.PHONY:shell
shell: ## Brings up the bash shell in dev docker
	docker compose --progress=plain build --parallel
	docker compose --progress=plain run --rm --name anonymizer_shell fhir-anonymizer /bin/sh

# config file format: https://github.com/microsoft/Tools-for-Health-Data-Anonymization/blob/master/docs/FHIR-anonymization.md#fhir-path-rules

.PHONY: run
run:
	rm -rf ./data/output/* && \
	docker compose run --rm --name fhir-anonymizer fhir-anonymizer anonymize -r -i /data/input/bailey/ -o /data/output/bailey/ -c /data/config/config.json -v && \
	make find_text

.PHONY: find_text
find_text:
	python3 find_text_in_files.py data/output/bailey bailey

.PHONY: up
up:
	docker compose up
