FROM techiescamp/jre-17:1.0.0

# Descargar CoreNLP y los modelos
WORKDIR /app
# Descargar la biblioteca CoreNLP y descomprimirla
RUN wget https://nlp.stanford.edu/software/stanford-corenlp-4.5.9.zip && \
    unzip stanford-corenlp-4.5.9.zip && \
    rm stanford-corenlp-4.5.9.zip

# Descargar modelos específicos para español
RUN wget https://nlp.stanford.edu/software/stanford-spanish-corenlp-4.5.9-models.jar -P /app/stanford-corenlp-4.5.9/ && \
    wget https://nlp.stanford.edu/software/stanford-english-corenlp-4.5.9-models.jar -P /app/stanford-corenlp-4.5.9/
    
# Configurar el servidor
#COPY StanfordCoreNLP-spanish.properties /app/stanford-corenlp-4.5.9/

EXPOSE 9000

CMD ["java", "-cp", "*", "-Xmx8g", "edu.stanford.nlp.pipeline.StanfordCoreNLPServer", "-port", "9000", "-timeout", "30000"]
