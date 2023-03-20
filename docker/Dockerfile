FROM python:3.10.10-slim-bullseye as base

ENV POETRY_VERSION 1.2.2
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PIP_NO_CACHE_DIR=false

RUN pip install --no-cache-dir pip==23.0.1 setuptools==67.6.0

ENV POETRY_HOME "/opt/poetry"
RUN python3 -m venv ${POETRY_HOME}
RUN ${POETRY_HOME}/bin/pip install "poetry==$POETRY_VERSION"
RUN ${POETRY_HOME}/bin/poetry --version

WORKDIR /opt/bee_heavy_healthcheck
COPY poetry.lock pyproject.toml ./

RUN ${POETRY_HOME}/bin/poetry install --only main

ARG git_version
ENV git_version ${git_version}
ARG git_tag
ENV git_tag ${git_tag}
ARG git_sha
ENV git_sha ${git_sha}

# # ########################################
# FROM base as prod
# COPY . /opt/bee_heavy_healthcheck

# RUN ${POETRY_HOME}/bin/poetry install --only main
# CMD ...


# ########################################
FROM base as test
RUN ${POETRY_HOME}/bin/poetry install --no-root
COPY . /opt/bee_heavy_healthcheck
RUN ${POETRY_HOME}/bin/poetry install

ARG pytest_flags
ENV pytest_flags ${pytest_flags}
CMD scripts/docker/cmd_docker_run_tests.sh
