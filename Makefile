SITE_NAME=codependentcodrbase
USER_NAME=pzelnip
SHA := $(shell git rev-parse --short HEAD)

dockerbuild:
	docker build -t $(SITE_NAME):latest .

safety: dockerbuild
	docker run -it --rm $(SITE_NAME):latest safety check -r /build/requirements.txt --full-report

dockerpush:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker tag $(SITE_NAME) $(USER_NAME)/$(SITE_NAME):latest
	docker tag $(SITE_NAME) $(USER_NAME)/$(SITE_NAME):$(SHA)
	docker push $(USER_NAME)/$(SITE_NAME):latest
	docker push $(USER_NAME)/$(SITE_NAME):$(SHA)

triggerdownstream:
	curl -s -X POST  -H "Content-Type: application/json" -H "Accept: application/json" -H "Travis-API-Version: 3" -H "Authorization: token $(TRAVIS_TOKEN)" -d '{ "request": { "branch":"mainline" }}' https://api.travis-ci.com/repo/pzelnip%2Fwww.codependentcodr.com/requests

deploy: dockerbuild safety dockerpush triggerdownstream

clean:
	docker images | grep $(SITE_NAME) | awk {'print $3'} | xargs docker rmi

.PHONY: dockerbuild dockerpush deploy safety
