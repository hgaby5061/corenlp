FROM techiescamp/jre-17:1.0.0  # Mejor usar imagen oficial

WORKDIR /app

# Instalar dependencias necesarias
RUN apt-get update && \
    apt-get install -y unzip && \
    rm -rf /var/lib/apt/lists/*

# Descargar y descomprimir CoreNLP
RUN curl -L -o stanford-corenlp-4.5.9.zip https://nlp.stanford.edu/software/stanford-corenlp-4.5.9.zip && \
    unzip stanford-corenlp-4.5.9.zip && \
    rm stanford-corenlp-4.5.9.zip

# Descargar modelos (sintaxis corregida)
RUN cd stanford-corenlp-4.5.9 && \
    curl -O https://nlp.stanford.edu/software/stanford-spanish-corenlp-4.5.9-models.jar && \
    curl -O https://nlp.stanford.edu/software/stanford-english-corenlp-4.5.9-models.jar

# Copiar configuración (si es necesario)
# COPY StanfordCoreNLP-spanish.properties /app/stanford-corenlp-4.5.9/

EXPOSE 9000

CMD ["java", 
     "-mx350m",  # Aumentar memoria para producción
     "-cp", 
     "*", 
     "edu.stanford.nlp.pipeline.StanfordCoreNLPServer", 
     "-port", "9000", 
     "-timeout", "30000"]
