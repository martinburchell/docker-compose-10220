FROM python:3.8-slim-buster

ARG USER_ID
RUN adduser --disabled-password --gecos '' --uid $USER_ID crate


ADD . /crate/src

WORKDIR /crate


RUN mkdir -p /crate/venv/foo


USER crate
