ARG DOCKER_USERNAME
ARG DOCKER_PASSWORD

FROM techiescamp/jdk-17:1.0.0 AS build 
# Utilizar una imagen base estable de Ubuntu
FROM ubuntu:22.04

# Instalar el JDK y herramientas necesarias
RUN apt-get update && apt-get install -y openjdk-11-jdk unzip curl && rm -rf /var/lib/apt/lists/*

# Establecer el directorio de trabajo
WORKDIR /app

# Descargar la última versión de CoreNLP
ARG CORENLP_VERSION=4.5.0
RUN curl -L -o corenlp.zip https://nlp.stanford.edu/software/stanford-corenlp-${CORENLP_VERSION}.zip \
    && unzip corenlp.zip -d /app \
    && rm corenlp.zip

# Descargar los modelos para español
RUN curl -L -o spanish-models.jar https://nlp.stanford.edu/software/stanford-spanish-corenlp-models-current.jar \
    && mv spanish-models.jar /app/stanford-corenlp-${CORENLP_VERSION}/

# Exponer el puerto del servidor
EXPOSE 9000

# Comando para ejecutar el servidor CoreNLP con los modelos precargados
CMD ["java", "-mx3g", "-cp", "/app/stanford-corenlp-4.5.0/*", "edu.stanford.nlp.pipeline.StanfordCoreNLPServer", "-port", "9000", "-timeout", "15000", "-logLevel", "DEBUG"]

