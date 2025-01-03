# First stage: Clone the repository
FROM ubuntu:latest as source-code

WORKDIR /App

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/Mamatha1296/Jenkin.git .
RUN git checkout main

# Second stage: Build the application
FROM ubuntu:latest as build

RUN apt-get update && apt-get install -y openjdk-17-jdk maven

# Set working directory inside container for building
WORKDIR /App  # Ensure Maven runs from the directory containing pom.xml

# Copy the source code from the first stage
COPY --from=source-code /App /App

# Run Maven build
RUN mvn clean package
