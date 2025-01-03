# Stage 1: Clone the GitHub repository
FROM ubuntu:latest as source-code

# Set the working directory
WORKDIR /App

# Install git to clone the repository
RUN apt-get update && apt-get install -y git

# Clone the repository
RUN git clone https://github.com/Mamatha1296/Jenkin.git .

# Checkout the main branch
RUN git checkout main

# Stage 2: Build the .war file using Maven
FROM maven:3.8.7-openjdk-17 as build

# Set the working directory
WORKDIR /build

# Copy the MyWebApp directory from Stage 1
COPY --from=source-code /App/App /build

# Package the application into a .war file
RUN mvn clean package

# Stage 3: Deploy to Tomcat
FROM tomcat:10.1.34

# Copy the WAR file from Stage 2 to the Tomcat webapps directory
COPY --from=build /build/target/App.war /usr/local/tomcat/webapps/App.war

# Expose port 9090
EXPOSE 9090

# Start Tomcat server
CMD ["catalina.sh", "run"]
