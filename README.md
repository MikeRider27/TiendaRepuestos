# TiendaRepuestos

Aplicación web (Servlets + JSP, Java EE 7) para la gestión de una tienda de repuestos: clientes, empleados, proveedores, repuestos, tipos de documento/servicio/empleado y ventas.

Originalmente corría sobre GlassFish + MySQL/MariaDB. Actualmente está dockerizada y migrada a **PostgreSQL**, desplegada sobre **Tomcat 9**.

## Stack

- Java 8, Servlets 3.0 (`@WebServlet`) + JSP, sin frameworks adicionales.
- Logging con Log4j 1.x.
- Persistencia con JDBC puro (`java.sql`) y procedimientos almacenados.
- Base de datos: PostgreSQL (antes MySQL/MariaDB).
- Contenedor: Tomcat 9 (`tomcat:9.0-jdk8-temurin`).

## Levantar el proyecto con Docker

Requiere Docker y acceso a un servidor PostgreSQL.

1. Copiar y ajustar las variables de conexión a la base de datos:

   ```bash
   cp .env.example .env   # si no existe .env, crearlo con las claves de abajo
   ```

   Variables usadas (ver `docker-compose.yml`):

   | Variable | Descripción | Valor de ejemplo |
   |---|---|---|
   | `DB_HOST` | Host del servidor PostgreSQL | `192.168.11.220` |
   | `DB_PORT` | Puerto de PostgreSQL | `5436` |
   | `DB_NAME` | Nombre de la base de datos | `irresistibles` |
   | `DB_USER` | Usuario de PostgreSQL | `postgres` |
   | `DB_PASSWORD` | Contraseña de PostgreSQL | *(requerida, sin valor por defecto)* |

   `.env` no se versiona (está en `.gitignore`) porque contiene la contraseña de la base de datos.

2. Construir y levantar el contenedor:

   ```bash
   docker compose up -d --build
   ```

3. Abrir la aplicación en `http://localhost:8085/TiendaRepuestos/` (el puerto host se define en `docker-compose.yml`, por defecto `8085:8080`).

Las variables de entorno se inyectan en tiempo de arranque del contenedor (`docker/entrypoint.sh` genera `WEB-INF/classes/jdbc.properties` a partir de `docker/jdbc.properties.template`), por lo que apuntar la app a otra base de datos no requiere reconstruir la imagen, solo reiniciar el contenedor con otras variables.

## Base de datos

El esquema, los datos y los procedimientos almacenados originales de MySQL están en `bd/irresistibles.sql`. La versión convertida a PostgreSQL vive en `bd/postgres/`:

- `01_schema_and_data.sql`: tablas, claves primarias/foráneas, datos y reajuste de secuencias.
- `02_functions.sql`: los procedimientos almacenados de MySQL convertidos a funciones PL/pgSQL con parámetro `OUT` (mismo patrón de llamada `CallableStatement` que ya usaban las clases DAO).

Para cargar el esquema en una base nueva:

```bash
psql -h <host> -p <puerto> -U postgres -d postgres -c "CREATE DATABASE irresistibles;"
psql -h <host> -p <puerto> -U postgres -d irresistibles -f bd/postgres/01_schema_and_data.sql
psql -h <host> -p <puerto> -U postgres -d irresistibles -f bd/postgres/02_functions.sql
```

## Usuarios de prueba

La tabla `login` guarda las contraseñas en MD5 (el navegador las hashea antes de enviarlas). Usuarios disponibles, todos con contraseña `123456`:


## Desarrollo sin Docker (NetBeans)

El proyecto conserva su estructura de proyecto NetBeans (`nbproject/`, `build.xml`) para quien prefiera compilarlo y desplegarlo directamente en GlassFish. En ese caso, editar `src/java/jdbc.properties` con los datos de conexión a PostgreSQL.

## 👨‍💻 Autor

Miguel Villalba
Desarrollador Full Stack
✉️ mike.mavc27@gmail.com

## 📄 Licencia

Este proyecto está bajo la licencia MIT.