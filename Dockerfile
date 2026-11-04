# The workshop's container for the legacy monolith (replatforming lab):
# Amazon Corretto 11, port 8080, MonoToMicroLegacy-0.0.1-SNAPSHOT.jar.
# The lab copies a prebuilt jar from S3; here it is built from source.
FROM amazoncorretto:11 AS build
RUN yum install -y findutils && yum clean all
WORKDIR /src
COPY MonoToMicroLegacy/ .
RUN chmod +x gradlew && ./gradlew build -x test --no-daemon

FROM amazoncorretto:11
COPY --from=build /src/build/libs/MonoToMicroLegacy-0.0.1-SNAPSHOT.jar /app.jar
EXPOSE 8080
# Reads MONO_TO_MICRO_DB_ENDPOINT (application.properties).
ENTRYPOINT ["java", "-jar", "/app.jar"]
