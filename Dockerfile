FROM openjdk:8u131-jre

MAINTAINER Deng You <1071102039@qq.com>

EXPOSE 8080

ENV JAVA_VER=1.8.0

RUN mkdir /projectname

ADD ./target/*.jar /projectname/app.jar

WORKDIR /projectname

USER 1001

CMD ["java","-jar","/projectname/app.jar"]