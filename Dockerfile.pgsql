ARG PG_VERSION=9.6

FROM postgres:$PG_VERSION

ENV TERM screen-256color

COPY ./.psqlrc /tmp/.psqlrc
RUN cat /tmp/.psqlrc > ~/.psqlrc

# vim: set ft=dockerfile:
