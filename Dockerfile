ARG CONDA_TAG=4.11.0
FROM continuumio/miniconda3:${CONDA_TAG}

SHELL ["/bin/bash", "-c"]
ARG POETRY_VERSION=1.2.0b2
ENV POETRY_VIRTUALENVS_PATH=/opt/conda/envs \
    CONDA_INIT=$CONDA_PREFIX/etc/profile.d/conda.sh

# install poetry in the base conda environment
RUN set +x \
        && source $CONDA_INIT \
        \
        && python -m pip install poetry==$POETRY_VERSION \
        \
        && poetry --version \
        \
        && apt-get update \
        \
        && apt-get install -y --no-install-recommends \
            gcc \
            linux-libc-dev \
            libc6-dev \
        \
        && rm -rf /var/lib/apt/lists/*

# add in pinto and install it into the
# base environment as well
ADD . /opt/pinto
RUN set +x \
        \
        && source $CONDA_INIT \
        \
        && cd /opt/pinto \
        \
        && pip install . \
        \
        && pinto --version
