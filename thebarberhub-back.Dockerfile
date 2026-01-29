FROM maven:3.9.11-eclipse-temurin-21-noble
 
ENV DEBIAN_FRONTEND=noninteractive
 
RUN apt-get update
RUN apt-get install -y git
 
RUN mkdir /opt/app
WORKDIR /opt/app
RUN git clone https://github.com/TheBarberHub-2/tienda-back.git
WORKDIR /opt/app/tienda-back
RUN git switch --detach origin/develop
RUN mvn clean install -DskipTests
 
EXPOSE 8080

CMD ["java","-jar", "target/tienda-back-0.0.1-SNAPSHOT.jar"]

