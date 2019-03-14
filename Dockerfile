FROM node:8.10.0-alpine AS intermediate
WORKDIR /app

# copy project file
COPY package.json .

# copy app files
COPY . .

# run install
CMD npm run install

#Install the packages and create node_modules folder
RUN npm set progress=false && npm install

FROM jenkins/jenkins:2.168-alpine
RUN mkdir -p /var/jenkins_home/workspace/devops_test1_pipeline
WORKDIR /var/jenkins_home/workspace/devops_test1_pipeline
COPY --from=intermediate /app/node_modules ./node_modules
EXPOSE 8080
