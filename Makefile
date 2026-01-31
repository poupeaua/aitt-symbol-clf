include .env
include .scripts/ensure_env_vars.mk

# instantiated env variables
CONTAINER_NAME=angle-symbol-clf-ctr
VERSION=$(shell poetry version -s)

# AWS_ACCOUNT_ID and AWS_REGION are expected to be set in the environment
TAG=${VERSION}
ECR_REGISTRY=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
ECR_REPOSITORY_URI=${ECR_REGISTRY}/${IMAGE_NAME}
ECR_REPOSITORY_URI_TAGGED=${ECR_REPOSITORY_URI}:${TAG}

run:
	fastapi dev api.py

build: check-env-vars
	docker build -t ${IMAGE_NAME} .

run-docker: check-env-vars
	docker run -p 8000:80 --name ${CONTAINER_NAME} --rm ${IMAGE_NAME}

deploy: check-env-vars build
	aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
	docker tag ${IMAGE_NAME} ${ECR_REPOSITORY_URI_TAGGED}
	docker push ${ECR_REPOSITORY_URI_TAGGED}
