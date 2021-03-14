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
    python3 make git curl

RUN python3 -m ensurepip && python3 -m pip install --upgrade pip --no-cache-dir

COPY requirements.txt /build/requirements.txt
COPY requirements-float.txt /build/requirements-float.txt

RUN python3 -m pip install -r /build/requirements-float.txt --no-cache-dir && \
    python3 -m pip install -r /build/requirements.txt --no-cache-dir
