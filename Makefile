build:
	docker build --progress plain -t fhir-anonymizer .

shell:
	docker run -it --rm fhir-anonymizer /bin/bash

up:
	rm -rf ./data/output/*
	docker-compose up
