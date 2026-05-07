FROM postgres:16-alpine

COPY postgres/init/01-schemas.sql /docker-entrypoint-initdb.d/01-schemas.sql

EXPOSE 5432