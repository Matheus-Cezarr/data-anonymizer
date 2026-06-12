# Estágio 1: Build robusto com Maven e Java 21
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .

# Localiza o pom.xml na raiz ou subpasta e compila o JAR
RUN POM_PATH=$(find . -name "pom.xml" -print -quit) && \
    DIR_PATH=$(dirname "$POM_PATH") && \
    cd "$DIR_PATH" && \
    mvn clean package -DskipTests && \
    mkdir -p /app/target_build && \
    cp target/*.jar /app/target_build/app.jar

# Estágio 2: Execução leve
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=build /app/target_build/app.jar app.jar
EXPOSE 8080

# Limitação de memória para o plano gratuito do Render
ENTRYPOINT ["java", "-XX:ActiveProcessorCount=1", "-Xmx300m", "-jar", "app.jar"]
