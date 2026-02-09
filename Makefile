include .env
include .scripts/ensure_env_vars.mk

# instantiated env variables
CONTAINER_NAME=angle-symbol-clf-ctr
VERSION=$(shell uv version --short)

# AWS_ACCOUNT_ID and AWS_REGION are expected to be set in the environment
TAG=${VERSION}
IMAGE_NAME_LOCAL=${IMAGE_NAME}-local
ECR_REGISTRY=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
ECR_REPOSITORY_URI=${ECR_REGISTRY}/${IMAGE_NAME}
ECR_REPOSITORY_URI_TAGGED=${ECR_REPOSITORY_URI}:${TAG}

run-local: check-env-vars
	fastapi dev api.py

build-local: check-env-vars
	docker build -t ${IMAGE_NAME_LOCAL} .

run-docker-local: check-env-vars
	docker run -p 8000:80 --name ${CONTAINER_NAME} --rm ${IMAGE_NAME_LOCAL}

# we need to define build for production that is platform agnostic
build: check-env-vars
	docker buildx build --platform linux/amd64 -t ${IMAGE_NAME}  .

deploy: check-env-vars build

	@echo "Checking if version $(TAG) already exists in ECR..."
	@if aws ecr describe-images --repository-name ${IMAGE_NAME} --image-ids imageTag=$(TAG); then \
		echo "❌ Error: Tag '$(TAG)' already exists in ECR. Version bump required!"; \
		exit 1; \
	else \
		echo "✅ Tag '$(TAG)' not found. Proceeding with push..."; \
	fi

	aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
	docker tag ${IMAGE_NAME} ${ECR_REPOSITORY_URI_TAGGED}
	docker push ${ECR_REPOSITORY_URI_TAGGED}
