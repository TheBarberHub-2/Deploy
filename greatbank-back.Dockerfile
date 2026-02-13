FROM maven:3.9.11-eclipse-temurin-21-noble

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y git

RUN mkdir /opt/app
WORKDIR /opt/app
RUN git clone -b PRE https://github.com/TheBarberHub-2/banco-back.git
WORKDIR /opt/app/banco-back/banco
RUN mvn clean install -DskipTests

EXPOSE 8080

CMD ["java","-jar", "target/banco-0.0.1-SNAPSHOT.jar"]

