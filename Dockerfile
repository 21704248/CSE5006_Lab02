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
# Create a working directory for our application
RUN mkdir -p /app
WORKDIR /app

# Install the project's NPM dependencies
COPY package.json /app/
RUN npm --silent install
RUN mkdir /deps && mv node_modules /deps/node_modules

# Set environment variables to point to the installed NPM modules
ENV NODE_PATH=/deps/node_modules \
PATH=/deps/node_modules/.bin:$PATH

# Copy our application files into the image
COPY . /app

# Switch to a non-priveleged user for running commands
RUN chown -R node:node /app /deps
USER node

# Expose container port 3000
EXPOSE 3000

# Set the default command to use for 'docker run'
# 'npm start' simply starts our server
CMD [ "npm", "start" ]