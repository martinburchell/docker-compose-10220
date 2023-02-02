FROM python:3.8-slim-buster

ARG USER_ID
RUN adduser --disabled-password --gecos '' --uid $USER_ID test

WORKDIR /test

RUN echo "- Creating Python 3 virtual environment..." \
    && python3 -m venv /test/venv \
    && echo "- Done."

USER test
