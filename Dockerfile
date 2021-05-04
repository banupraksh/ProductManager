FROM openjdk:8-alpine

RUN apk update && apk add /bin/sh

RUN mkdir -p /opt/app

ENV PROJECT_HOME /opt/app

COPY target/ProductManager*.jar $PROJECT_HOME/ProductManager.jar

WORKDIR $PROJECT_HOME

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","./ProductManager.jar"]
