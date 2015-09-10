FROM ubuntu:14.04
 
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8
RUN echo "export PS1='\e[1;31m\]\u@\h:\w\\$\[\e[0m\] '" >> /root/.bashrc

#Runit
RUN apt-get install -y runit 
CMD export > /etc/envvars && /usr/sbin/runsvdir-start
RUN echo 'export > /etc/envvars' >> /root/.bashrc

#Utilities
RUN apt-get install -y vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common jq psmisc
RUN apt-get install -y build-essential
RUN apt-get install -y nginx

#Node
RUN wget -O - http://nodejs.org/dist/v0.12.7/node-v0.12.7-linux-x64.tar.gz | tar xz
RUN mv node* node && \
    ln -s /node/bin/node /usr/local/bin/node && \
    ln -s /node/bin/npm /usr/local/bin/npm
ENV NODE_PATH /usr/local/lib/node_modules
RUN npm config set loglevel info

#tools
RUN npm install -g grunt-cli

#noflo-ui
RUN git clone --depth 1 https://github.com/noflo/noflo-ui.git
RUN cd noflo-ui && \
    npm install && \
    grunt build

COPY nginx.conf /etc/nginx/

#Add runit services
ADD sv /etc/service 

