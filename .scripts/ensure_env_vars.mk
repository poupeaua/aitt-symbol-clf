.PHONY: check-env-vars

define check_var
	@if [ -z "$(1)" ]; then \
		echo "❌ ERROR: $(2) is not set"; exit 1; \
	fi
endef

check-env-vars:
	$(call check_var,$(AWS_ACCOUNT_ID),AWS_ACCOUNT_ID)
	$(call check_var,$(AWS_REGION),AWS_REGION)
	$(call check_var,$(IMAGE_NAME),IMAGE_NAME)
	$(call check_var,$(DOCKER_NETWORK),DOCKER_NETWORK)
	$(call check_var,$(CONTAINER_NAME),CONTAINER_NAME)
	@echo "✅ All required environment variables are set."