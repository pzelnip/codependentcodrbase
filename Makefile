SITE_NAME=codependentcodrbase
USER_NAME=pzelnip
SHA := $(shell git rev-parse --short HEAD)

dockerbuild:
	docker build -t $(SITE_NAME):latest .

dockerpush:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker tag $(SITE_NAME) $(USER_NAME)/$(SITE_NAME):latest
	docker tag $(SITE_NAME) $(USER_NAME)/$(SITE_NAME):$(SHA)
	docker push $(USER_NAME)/$(SITE_NAME):latest
	docker push $(USER_NAME)/$(SITE_NAME):$(SHA)

deploy: dockerbuild dockerpush
