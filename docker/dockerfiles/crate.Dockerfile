FROM python:3.8-slim-buster

ARG USER_ID
RUN adduser --disabled-password --gecos '' --uid $USER_ID crate


ADD . /crate/src

WORKDIR /crate


RUN echo "===============================================================================" \
    && echo "CRATE" \
    && echo "===============================================================================" \
    && echo "- Creating Python 3 virtual environment..." \
    && python3 -m venv /crate/venv \
    && echo "- Done."


USER crate
