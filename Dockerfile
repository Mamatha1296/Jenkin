# Stage 1: Clone the source code
FROM ubuntu:latest as source-code
WORKDIR /App
RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/Mamatha1296/Jenkin.git .
RUN ls -al /App  # This will list files and ensure pom.xml is in /App

# Stage 2: Build the project
FROM ubuntu:latest as build
WORKDIR /App
RUN apt-get update && apt-get install -y openjdk-17-jdk maven
COPY --from=source-code /App /App  # Copy the files from the source-code stage
RUN ls -al /App  # Verify pom.xml is copied correctly

# Run Maven build (this will generate the target folder with WAR file)
RUN mvn clean package

# Stage 3: Final image to run application (optional, depending on how you want to use it)
FROM openjdk:17-jdk-slim
WORKDIR /App
COPY --from=build /App/target/App.war /App/App.war  # Copy the WAR file into the final image

# Expose the port your app will run on (if running a web server, for example)
EXPOSE 8080

# Start the app (for example, if running via a web server)
CMD ["java", "-jar", "/App/App.war"]
