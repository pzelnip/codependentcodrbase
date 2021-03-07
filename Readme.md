# Codependent Codr Base Image

[![Actions Status](https://github.com/pzelnip/codependentcodrbase/workflows/Build%20And%20Push%20Image/badge.svg)](https://github.com/pzelnip/codependentcodrbase/actions)

This is the base Docker image that I use for my blog.

The repo for that is more interesting and you can find it at:

<https://github.com/pzelnip/www.codependentcodr.com>

## The Point Of This

Originally the CDC repo had a single Dockerfile which contained
all the stuff in the Dockerfile here.  What I found though was
that installing git, curl, npm, etc on every build when I posted
a new blog post really made for some long builds.

Those packages almost never change, so I pulled that stuff out
into the Dockerfile you find here in this repo.  I then use that
built image as the base image for CDC builds, which speeds up
my build times for that repo.
