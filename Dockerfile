# First stage: Clone the repository
FROM ubuntu:latest as source-code

WORKDIR /App

RUN apt-get update && apt-get install -y git

# Clone the repository and checkout the main branch
RUN git clone https://github.com/Mamatha1296/Jenkin.git . 
RUN git checkout main

# Second stage: Build the application
FROM ubuntu:latest as build

RUN apt-get update && apt-get install -y openjdk-17-jdk maven

# Ensure Maven works in the correct directory (the directory containing pom.xml)
WORKDIR /App

# Copy the source code (including pom.xml) from the first stage
COPY --from=source-code /App /App

# Run Maven build inside /App (where pom.xml is located)
RUN ls -al /App  # This will list files to confirm that pom.xml is present
RUN mvn clean package
