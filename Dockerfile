FROM openjdk:17-alpine
RUN addgroup -S spring && adduser -S spring -G spring
RUN apk add ttf-dejavu
USER spring:spring
COPY target/*.jar app.jar
ENTRYPOINT ["java", "-Xmx300m", "-jar", "/app.jar"]