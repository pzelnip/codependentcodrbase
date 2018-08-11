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

# needed for Pylint 2.0.0
RUN apk add --no-cache --update python3-dev gcc build-base

RUN npm install -g markdownlint-cli
