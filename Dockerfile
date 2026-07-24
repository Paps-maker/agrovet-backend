# Stage 1: Build the application using Maven
FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app

# Copy pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build the jar file using standard maven (installed via apt)
RUN apt-get update && apt-get install -y maven
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/*.jar app.jar

# Railway dynamic port support
EXPOSE 8081

ENTRYPOINT ["java", "-jar", "app.jar"]