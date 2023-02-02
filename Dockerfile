FROM python:3.8-slim-buster

ADD . /test/src

WORKDIR /test


RUN mkdir -p /test/foo/bar
