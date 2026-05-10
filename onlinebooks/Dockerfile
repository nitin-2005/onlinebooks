# Build stage
FROM maven:3.9.6-eclipse-temurin-11 AS build
WORKDIR /app
COPY pom.xml .
# Download dependencies first to speed up subsequent builds
RUN mvn dependency:go-offline -B

COPY src ./src
COPY WebContent ./WebContent
RUN mvn clean package -DskipTests

# Run stage
FROM tomcat:10.1.23-jdk11-temurin
# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy built war file and extract it to ROOT directory
COPY --from=build /app/target/onlinebooks.war /tmp/ROOT.war
RUN mkdir -p /usr/local/tomcat/webapps/ROOT && \
    cd /usr/local/tomcat/webapps/ROOT && \
    jar xf /tmp/ROOT.war && \
    rm /tmp/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
