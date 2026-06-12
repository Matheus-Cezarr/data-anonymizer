# Estágio 1: Build apontando direto para a pasta correta
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .

# Entra direto na pasta onde o projeto real está e compila
RUN cd data-anonymizer && mvn clean package -DskipTests

# Estágio 2: Execução leve
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Copia o JAR gerado de dentro da pasta do projeto
COPY --from=build /app/data-anonymizer/target/*.jar app.jar
EXPOSE 8080

ENTRYPOINT ["java", "-XX:ActiveProcessorCount=1", "-Xmx300m", "-jar", "app.jar"]
