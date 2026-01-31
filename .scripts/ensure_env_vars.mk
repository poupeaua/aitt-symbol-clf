.PHONY: check-env-vars

check-env-vars:
	@if [ -z "$(AWS_ACCOUNT_ID)" ]; then \
		echo "ERROR: AWS_ACCOUNT_ID is not set"; exit 1; \
	fi
	@if [ -z "$(AWS_REGION)" ]; then \
		echo "ERROR: AWS_REGION is not set"; exit 1; \
	fi
	@if [ -z "$(IMAGE_NAME)" ]; then \
		echo "ERROR: IMAGE_NAME is not set"; exit 1; \
	fi

	@echo "✅ All required environment variables are set."