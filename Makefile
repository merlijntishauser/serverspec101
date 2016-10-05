DOCKER_IMAGE = merlijntishauser/apache-test

build:
	docker build -t $(DOCKER_IMAGE) $(CURDIR)

.PHONY: test

test:
	@echo "linting the Dockerfile"
	@docker run --rm -i lukasmartinelli/hadolint hadolint --ignore DL3008 --ignore DL3013 - < Dockerfile
	@echo "running serverspec tests on the Dockerfile"
	@cd tests; rake --silent --quiet
