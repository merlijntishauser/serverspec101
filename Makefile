DOCKER_IMAGE = merlijntishauser/apache-test

.PHONY: test build

build:
	docker build -t $(DOCKER_IMAGE) $(CURDIR)

push-docker: build
	docker push $(DOCKER_IMAGE):latest

pull-docker:
	docker pull $(DOCKER_IMAGE):latest

lint:
	@echo "start linting the Dockerfile"
	@docker run --rm -i fourstacks/hadolint:release-0.1 hadolint --ignore DL3008 --ignore DL3013 - < Dockerfile
	@echo "finished linting the Dockerfile"

remove-local-testdocker:
	-@docker rm -f testdocker

test: lint
	@echo "running serverspec tests on the Dockerfile"
	@docker run --rm -i -e "CONTNAME=testdocker" --name testdocker -v "/var/run/docker.sock:/var/run/docker.sock" -v "$(PWD):/projectfiles" --workdir "/projectfiles/tests" fourstacks/serverspec:release-0.3.5 rake
