# start with a lightweight linux OS with node pre-installed
FROM node:18-alpine

# set working directory inside the container
WORKDIR /app

# copy dependency definitions
COPY package*.json ./

# install dependencies inside container environment
RUN npm install

# copy rest of application code
COPY . .

# switch to non-root user for security
USER node

# document network port the app uses
EXPOSE 3000

# define commands that will be run when the container starts
CMD ["npm", "start"]