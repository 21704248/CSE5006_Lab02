# Base this image on an official Node.js long term support image.
## *Base* the image on node:8.0.0-alpine
FROM node:8.1.2-alpine


### Modify the base image

# Download and install Tini. Tini will act as the init process.
# Install Tini using Alpine Linux's package manager, apk.
RUN apk add --no-cache tini

# Use Tini as the init process. Tini will take care of system stuff for us, like forwarding signals and reaping zombie processes.
ENTRYPOINT ["/sbin/tini", "--"]


## Add the custom Express software to the docker image
