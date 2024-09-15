## Start with a base image containing Java runtime
#FROM openjdk:21-jdk-slim as build
#
## Add Maintainer Info
#LABEL maintainer="ngaurav456@gmail.com"
#
## Add a volume pointing to /tmp
#VOLUME /tmp
#
## Make port 8080 available to the world outside this container
#EXPOSE 8080
#
## The application's jar file
#ARG JAR_FILE=target/demo-0.0.1-SNAPSHOT.jar
#
## Add the application's jar to the container
#ADD ${JAR_FILE} ea-project-demo.jar
#
## Run the jar file
#ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/ea-project-demo.jar"]
#


# Use the official Maven image to build the application
FROM maven:3.9.9-ibm-semeru-21-jammy AS build

# Set the working directory
WORKDIR /app

# Copy the Maven project files
COPY pom.xml .
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Use the official OpenJDK image to run the application
FROM openjdk:21-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar app.jar

# Expose the port on which the application will run
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
