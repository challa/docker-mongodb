FROM srinivasachalla/docker-ubuntu
MAINTAINER SAP SE

# Install MongoDB 3.0
ENV MONGO_USER="mongod"

# Add create-user
RUN  echo "creating user '$MONGO_USER' "

RUN  /usr/sbin/adduser \
      --system \
      --group \
      --shell /bin/bash \
      --disabled-password \
      --home /home/mongod mongod \
      --gecos "Dedicated mongodb user"

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.0.list && \
    apt-get update && \
    apt-get install -y --force-yes mongodb-org=3.0.7 mongodb-org-server=3.0.7 mongodb-org-shell=3.0.7 mongodb-org-mongos=3.0.7 mongodb-org-tools=3.0.7 runit && \
    service mongod stop && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add scripts
ADD scripts /scripts

# Expose listen port
EXPOSE 27017
EXPOSE 28017

# Add privileges to 'mongod' user
RUN \
   mkdir /data && \
   chown -R mongod:mongod /data && \ 
   chown -R mongod:mongod /usr/bin/mongod && \
   chown -R mongod:mongod /tmp && \
   chmod +x /scripts/*.sh && \
   chown -R mongod:mongod /scripts

# Expose our data volumes
VOLUME ["/data"]

# Use MONGO_USER
USER $MONGO_USER

# Touch /scripts/.firstrun as MONGO_USER
RUN touch /scripts/.firstrun

# Command to run
ENTRYPOINT ["/scripts/run.sh"]
CMD [""]
