#!/bin/bash

image_name=aitt-symbol-clf
container_name=aitt-symbol-clf-ctr

run:
	fastapi dev api.py

build:
	docker build -t ${image_name} .

run-docker:
	docker run -p 8000:80 --name ${container_name} --rm ${image_name}