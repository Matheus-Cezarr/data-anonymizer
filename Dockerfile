# Estágio 1: Build direto no diretório atual
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .

# Lista os arquivos para o log (ajuda a inspecionar se necessário) e compila na raiz atual
RUN ls -la && mvn clean package -DskipTests

# Estágio 2: Execução leve
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Copia o JAR gerado de qualquer pasta target que tenha sido criada
RUN mkdir -p /app/target_build
COPY --from=build /app/**/target/*.jar /app/target_build/app.jar

WORKDIR /app/target_build
EXPOSE 8080

ENTRYPOINT ["java", "-XX:ActiveProcessorCount=1", "-Xmx300m", "-jar", "app.jar"]
