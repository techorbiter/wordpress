# syntax=docker/dockerfile:1

ARG PHP_VERSION=8.3
FROM docker.io/wordpress:php${PHP_VERSION}-fpm

RUN --mount=type=bind,from=ghcr.io/php/pie:bin,source=/pie,target=/usr/local/bin/pie \
 export DEBIAN_FRONTEND="noninteractive"; \
 set -eux; \
 apt-get update; \
 apt-get install -y --no-install-recommends unzip libtool; \
 pie install --no-cache igbinary/igbinary; \
 pie install --no-cache apcu/apcu; \
 apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false unzip libtool; \
 rm -rf /var/lib/apt/lists/*;

COPY config/* $PHP_INI_DIR/conf.d/
