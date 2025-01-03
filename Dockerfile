# Stage 1: Source code setup
FROM ubuntu:latest as source-code

SHELL ["/bin/bash", "-c"]

WORKDIR /App
RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/Mamatha1296/Jenkin.git .

# Stage 2: Build the project
FROM ubuntu:latest as build

# Install dependencies
RUN apt-get update && apt-get install -y openjdk-17-jdk maven

# Set the working directory to /App (inside the container)
WORKDIR /App

# Copy the content from the source-code stage
COPY --from=source-code /Jenkin/App  # This should point to Jenkins/App directory

# Debug step: Check that pom.xml is present
RUN ls -al /App

# Run Maven to build the project
RUN mvn clean package
