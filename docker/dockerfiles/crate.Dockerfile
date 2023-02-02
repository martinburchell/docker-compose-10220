FROM python:3.8-slim-buster

ADD . /crate/src

WORKDIR /crate


RUN mkdir -p /crate/venv/foo
