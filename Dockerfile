# syntax=docker/dockerfile:1

ARG PHP_VERSION=8.3
FROM docker.io/wordpress:php${PHP_VERSION}-fpm

#RUN set -ex; \
#    pecl install apcu-5.1.28; \
#    pecl install igbinary-3.2.16; \
#    docker-php-ext-enable apcu igbinary; \
#    rm -r /tmp/pear;

RUN --mount=type=bind,from=ghcr.io/php/pie:bin,source=/pie,target=/usr/local/bin/pie \
    export DEBIAN_FRONTEND="noninteractive"; \
    set -eux; \
    # Add the `unzip` package which PIE uses to extract .zip files.
    apt-get update; \
    apt-get install -y --no-install-recommends unzip; \
    # Use PIE to install an extension...
    pie install --no-cache igbinary/igbinary; \
    pie install --no-cache apcu/apcu; \
    # Clean up `unzip`.
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false unzip; \
    rm -rf /var/lib/apt/lists/*;

COPY config/* $PHP_INI_DIR/conf.d/
