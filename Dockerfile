# Etapa 1: build do projeto com Maven e Java 21
FROM maven:3.9.9-eclipse-temurin-21 AS build

# Metadados da imagem
LABEL maintainer="joaovic"
LABEL version="1.0"
LABEL description="API Java com Spring Boot, MySQL e Docker"

# Argumento usado durante o build
ARG APP_NAME=api-devops

# Diretório de trabalho dentro do container
WORKDIR /app

# Variáveis de ambiente do banco
ENV MYSQL_HOST=mysql
ENV MYSQL_PORT=3306
ENV MYSQL_DATABASE=api_devops_db
ENV MYSQL_USER=rm560907
ENV MYSQL_PASSWORD=Fiap@2026

# Copia o pom.xml primeiro para aproveitar cache das dependências
COPY pom.xml .

# Baixa as dependências antes de copiar todo o código
RUN mvn dependency:go-offline

# Copia os arquivos fonte do projeto
ADD src ./src

# Gera o arquivo .jar da aplicação
RUN mvn clean package -DskipTests


# Etapa 2: imagem final para execução da aplicação
FROM eclipse-temurin:21-jdk-jammy

# Metadados da imagem final
LABEL application="api-devops"
LABEL version="1.0"
LABEL description="Container de execução da API Java com Spring Boot"

# Argumento usado na imagem final
ARG APP_NAME=api-devops

# Variáveis de ambiente do banco
ENV MYSQL_HOST=mysql
ENV MYSQL_PORT=3306
ENV MYSQL_DATABASE=api_devops_db
ENV MYSQL_USER=rm560907
ENV MYSQL_PASSWORD=Fiap@2026

# Diretório de trabalho dentro do container
WORKDIR /app

# Copia o .jar gerado na etapa de build
COPY --from=build /app/target/*.jar app.jar

# Volume para armazenar logs da aplicação
VOLUME /app/logs

# Porta usada pela aplicação Spring Boot
EXPOSE 8080

# Cria um usuário próprio para rodar a aplicação
RUN useradd -ms /bin/bash appuser

# Define que a aplicação será executada com o usuário criado
USER appuser

# Comando de inicialização da aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]