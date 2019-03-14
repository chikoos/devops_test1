FROM node:8.10.0-alpine AS intermediate
WORKDIR /app
ARG SSH_PRIVATE_KEY

#Install dependencies required to git clone.
RUN apk update && \
    apk add --update git && \
    apk add --update openssh
	
RUN mkdir -p /root/.ssh/ && \
    echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa && \
    chmod -R 600 /root/.ssh/ && \
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

# clone github repo.
RUN git clone git@github.com:chikoos/devops_test1.git

#Install the packages and create node_modules folder
RUN npm install

FROM jenkins/jenkins:2.168-alpine
RUN mkdir /var/jenkins_home/workspace/devops_test1_pipeline
WORKDIR /var/jenkins_home/workspace/devops_test1_pipeline
COPY --from=intermediate /app/devops_test1/node_modules ./node_modules
