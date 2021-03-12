SITE_NAME=codependentcodrbase
USER_NAME=pzelnip
SHA := $(shell git rev-parse --short HEAD)

dockerbuild:
	docker build -t $(SITE_NAME):latest .

safety:
	cat requirements.txt | docker run -i --rm pyupio/safety safety check --stdin
	cat requirements-float.txt | docker run -i --rm pyupio/safety safety check --stdin

dockerlogin:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin

dockerpush: dockerlogin
	docker tag $(SITE_NAME) $(USER_NAME)/$(SITE_NAME):latest
	docker tag $(SITE_NAME) $(USER_NAME)/$(SITE_NAME):$(SHA)
	docker push $(USER_NAME)/$(SITE_NAME):latest
	docker push $(USER_NAME)/$(SITE_NAME):$(SHA)

dockerpull:
	docker pull $(USER_NAME)/$(SITE_NAME):latest

deploy: dockerbuild safety dockerpush

quickscan:
	cat requirements.txt | docker run -i --rm pyupio/safety safety check --stdin
	cat requirements-float.txt | docker run -i --rm pyupio/safety safety check --stdin

clean:
	docker images | grep $(SITE_NAME) | awk {'print $3'} | xargs docker rmi

.PHONY: dockerbuild dockerpush deploy safety
