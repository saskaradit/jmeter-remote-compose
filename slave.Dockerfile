FROM alpine:3.12

LABEL maintainer="raditya.saskara@gdn-commerce.com"

ARG JMETER_VERSION="5.3"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}

RUN apk update \
  && apk upgrade \
  && apk add ca-certificates \
  && update-ca-certificates \
  && apk add --update openjdk8-jre tzdata curl unzip bash \
  && apk add --no-cache nss \
  && rm -rf /var/cache/apk/* \
  && mkdir -p /tmp/dependencies \
  && curl -L --silent https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz > /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz \
  && mkdir -p /opt \
  && tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt \
  && rm -rf /tmp/dependencies

RUN sed -i 's/#server.rmi.ssl.disable=false/server.rmi.ssl.disable=true/' ${JMETER_HOME}/bin/user.properties

ENV PATH ${JMETER_HOME}/bin:$PATH

EXPOSE 1099 50000

ENTRYPOINT ${JMETER_HOME}/bin/jmeter-server \
  -D server.rmi.localport=50000 \
  -D server_port=1099

# HOW TO BUILD
# JMETER_VERSION="5.3"
# docker build -f jmeter.Dockerfile --build-arg JMETER_VERSION=5.3 -t "saskaradit/jmeter:5.3" .