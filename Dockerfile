FROM alpine:latest

# Base image to use for builds on the Codependent Codr website
#
# Previously this was all in that site's Dockerfile, but I found
# the installation of npm & the markdownlint gem to be rather
# slow (wasn't uncommon for npm to timeout on Travis builds)
#
# So now we build this base image and use that as the base
# image for CDC builds

RUN apk add --no-cache --update \
    python3 nodejs-current-npm make git curl

RUN python3 -m ensurepip
RUN pip3 install --upgrade pip

RUN npm install -g markdownlint-cli

# needed for Pylint 2.0.0
COPY requirements.txt /build/requirements.txt
COPY requirements-float.txt /build/requirements-float.txt

# Note that these 3 commands have to be combined to save on built
# image size.  If we separate into multiple Docker commands then
# doing the del after the fact has no effect because Docker *layers*
# the filesystem.  See: https://github.com/gliderlabs/docker-alpine/issues/45
# With this all as one command I found I saved over 100MB on the final
# built image.
RUN apk add --no-cache --update python3-dev gcc build-base && \
    pip3 install -r /build/requirements-float.txt && \
    pip3 install -r /build/requirements.txt && \
    apk del python3-dev gcc build-base
