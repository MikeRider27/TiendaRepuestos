FROM tomcat:9.0-jdk8-temurin

# ---- Compilar la aplicacion -------------------------------------------------
WORKDIR /build
COPY src ./src
COPY web ./web
COPY lib ./lib

RUN set -eux; \
    mkdir -p classes; \
    CP="$(find /usr/local/tomcat/lib -name '*.jar' | tr '\n' ':')$(find lib -name '*.jar' | tr '\n' ':')"; \
    javac -encoding UTF-8 -source 1.8 -target 1.8 -nowarn \
        -cp "$CP" \
        -d classes \
        $(find src/java -name '*.java'); \
    mkdir -p web/WEB-INF/classes web/WEB-INF/lib; \
    cp -r classes/* web/WEB-INF/classes/; \
    cp src/java/log4j.properties web/WEB-INF/classes/; \
    cp lib/log4j-1.2.16.jar lib/PostgreSQLDriver/postgresql-42.2.16.jar web/WEB-INF/lib/

# ---- Desplegar en Tomcat como directorio expandido --------------------------
RUN rm -rf /usr/local/tomcat/webapps/ROOT
RUN mkdir -p /usr/local/tomcat/webapps/TiendaRepuestos
RUN cp -r /build/web/* /usr/local/tomcat/webapps/TiendaRepuestos/
RUN rm -rf /build

COPY docker/jdbc.properties.template /usr/local/tomcat/jdbc.properties.template
COPY docker/entrypoint.sh /usr/local/tomcat/entrypoint.sh
RUN chmod +x /usr/local/tomcat/entrypoint.sh

# Valores por defecto no sensibles; host/puerto/BD pueden quedar aqui porque
# no son secretos. DB_USER y DB_PASSWORD se pasan en tiempo de ejecucion
# (ver docker-compose.yml / .env) para no dejar la contraseña grabada en la imagen.
ENV DB_HOST=192.168.11.220 \
    DB_PORT=5436 \
    DB_NAME=irresistibles

EXPOSE 8080

ENTRYPOINT ["/usr/local/tomcat/entrypoint.sh"]
