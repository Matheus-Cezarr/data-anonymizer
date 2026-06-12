# Etapa de construção
FROM maven:3.8.1-jdk-11 AS builder
WORKDIR /app

# Copia todos os arquivos para o contêiner
COPY . .

# Muda para o diretório correto e constrói o projeto
RUN cd data-anonymizer/data-anonymizer && mvn clean package -DskipTests

# Etapa de execução
FROM openjdk:11-jre-slim
WORKDIR /app

# Copia o arquivo JAR construído da etapa anterior
COPY --from=builder /app/data-anonymizer/data-anonymizer/target/*.jar app.jar

# Comando para executar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]
