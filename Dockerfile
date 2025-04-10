ARG DOCKER_USERNAME
ARG DOCKER_PASSWORD

# Utilizar una imagen base estable de Ubuntu
FROM ubuntu:22.04

# Instalar el JDK y herramientas necesarias
RUN apt-get update && apt-get install -y openjdk-11-jdk unzip curl && rm -rf /var/lib/apt/lists/*

# Establecer el directorio de trabajo
WORKDIR /app

# Crear el directorio para modelos
RUN mkdir -p /app/models

# Crear un directorio para las dependencias
RUN mkdir -p /app/libs

# Descargar la última versión de CoreNLP
ARG CORENLP_VERSION=4.5.0
RUN curl -L -o corenlp.zip https://nlp.stanford.edu/software/stanford-corenlp-${CORENLP_VERSION}.zip \
    && unzip corenlp.zip -d /app \
    && rm corenlp.zip
    
RUN curl -L -o models.jar https://nlp.stanford.edu/software/stanford-corenlp-${CORENLP_VERSION}-models.jar \
    && mv models.jar /app/stanford-corenlp-${CORENLP_VERSION}/

# Descargar los modelos para español
RUN curl -L -o spanish-models.jar https://nlp.stanford.edu/software/stanford-spanish-corenlp-models-current.jar \
    && mv spanish-models.jar /app/stanford-corenlp-${CORENLP_VERSION}/

# Descargar las dependencias necesarias
RUN curl -L -o jollyday.jar https://repo1.maven.org/maven2/de/jollyday/jollyday/0.5.2/jollyday-0.5.2.jar \
    && curl -L -o ejml-simple.jar https://repo1.maven.org/maven2/org/ejml/ejml-simple/0.40/ejml-simple-0.40.jar \
    && curl -L -o ejml-core.jar https://repo1.maven.org/maven2/org/ejml/ejml-core/0.40/ejml-core-0.40.jar \
    && curl -L -o joda-time.jar https://repo1.maven.org/maven2/joda-time/joda-time/2.12.2/joda-time-2.12.2.jar \
    && curl -L -o jaxb-impl.jar https://repo1.maven.org/maven2/com/sun/xml/bind/jaxb-impl/2.3.3/jaxb-impl-2.3.3.jar \
    && curl -L -o jaxb-api.jar https://repo1.maven.org/maven2/javax/xml/bind/jaxb-api/2.3.1/jaxb-api-2.3.1.jar \
    && curl -L -o istack-commons-runtime.jar https://repo1.maven.org/maven2/com/sun/istack/istack-commons-runtime/3.0.12/istack-commons-runtime-3.0.12.jar \
    && curl -L -o activation.jar https://repo1.maven.org/maven2/javax/activation/activation/1.1.1/activation-1.1.1.jar \
    && curl -L -o protobuf.jar https://repo1.maven.org/maven2/com/google/protobuf/protobuf-java/3.21.12/protobuf-java-3.21.12.jar \
    && curl -L -o dense.jar https://repo1.maven.org/maven2/org/ejml/dense/0.40/dense-0.40.jar

# Mover las dependencias al directorio libs
RUN mv jollyday.jar ejml-simple.jar ejml-core.jar joda-time.jar jaxb-impl.jar jaxb-api.jar istack-commons-runtime.jar activation.jar protobuf.jar dense.jar /app/libs/

# Exponer el puerto del servidor
EXPOSE 9000

# Comando para ejecutar el servidor CoreNLP con los modelos precargados
CMD ["java", "-mx3g", "-cp", "/app/stanford-corenlp-4.5.0/*:/app/libs/*", "edu.stanford.nlp.pipeline.StanfordCoreNLPServer", "-port", "9000", "-timeout", "60000", "-logLevel", "DEBUG","-modeldir","/app/stanford-corenlp-4.5.0/"]
