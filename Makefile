DOCKER_IMAGE = merlijntishauser/apache-test

.PHONY: test build

build:
	docker build -t $(DOCKER_IMAGE) $(CURDIR)

push-docker: build
	docker push $(DOCKER_IMAGE):latest

pull-docker:
	docker pull $(DOCKER_IMAGE):latest

test:
	@echo "linting the Dockerfile"
	@docker run --rm -i lukasmartinelli/hadolint hadolint --ignore DL3008 --ignore DL3013 - < Dockerfile
	@echo "running serverspec tests on the Dockerfile"
	@docker rm -f testdocker
	@docker run -it -e "CONTNAME=testdocker" --name testdocker -v "/var/run/docker.sock:/var/run/docker.sock" -v "$(PWD):/projectfiles" fourstacks/serverspec
