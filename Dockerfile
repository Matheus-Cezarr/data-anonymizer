# Estágio 1: Build apontando para o caminho real do repositório
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .

# Entra na estrutura real de pastas do seu GitHub e compila
RUN cd data-anonymizer/data-anonymizer && mvn clean package -DskipTests

# Estágio 2: Execução
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Copia o JAR direto do local correto
COPY --from=build /app/data-anonymizer/data-anonymizer/target/*.jar app.jar
EXPOSE 8080

ENTRYPOINT ["java", "-XX:ActiveProcessorCount=1", "-Xmx300m", "-jar", "app.jar"]
