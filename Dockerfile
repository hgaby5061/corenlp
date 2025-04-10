ARG DOCKER_USERNAME
ARG DOCKER_PASSWORD

FROM techiescamp/jdk-17:1.0.0 AS build 

# Establecer el directorio de trabajo
WORKDIR /app

# Instalar dependencias necesarias
RUN apt-get update && \
    apt-get install -y unzip && \
    rm -rf /var/lib/apt/lists/*

# Descargar la última versión de CoreNLP (ajustar la versión según sea necesario)
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
CMD ["java", "-mx1g", "-cp", "/app/stanford-corenlp-4.5.0/*", "edu.stanford.nlp.pipeline.StanfordCoreNLPServer", "-port", "9000", "-timeout", "15000", "-preload", "tokenize,ssplit,pos,lemma,ner,parse,depparse"]

# Copiar configuración (si es necesario)
# COPY StanfordCoreNLP-spanish.properties /app/stanford-corenlp-4.5.9/

#Imagen final
#FROM techiescamp/jre-17:1.0.0
#WORKDIR /app

# 3. Copiar solo lo necesario
#COPY --from=builder /app/stanford-corenlp-4.5.9 /app

# 4. Configuración esencial
#ENV JAVA_OPTS="-Xmx2g -Xms1g"


#CMD ["java",       
     #"-cp", "/app/*",
     #"edu.stanford.nlp.pipeline.StanfordCoreNLPServer", 
     #"-port", "9000", 
     #"-timeout", "30000"]
