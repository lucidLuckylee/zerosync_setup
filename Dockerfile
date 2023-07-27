FROM ubuntu:22.04

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git libgmp3-dev curl gcc make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev time

# Get pyenv
RUN git clone --depth=1 https://github.com/pyenv/pyenv.git .pyenv
ENV PYENV_ROOT="${HOME}/.pyenv"
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"

# Install python 
ENV PYTHON_VERSION=3.9.13
RUN pyenv install ${PYTHON_VERSION}
RUN pyenv global ${PYTHON_VERSION}

# Install cairo-lang
RUN pip install ecdsa fastecdsa sympy cairo-lang==0.12.0

# Intall Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup toolchain install nightly

WORKDIR /root/home
# Clone repos
# Add ssh key for private repos
# YOU MAY NEED TO CHANGE THIS LINE OR SET UP THE SSH KEY-PAIR
RUN mkdir -p /root/.ssh
COPY id_ed25519_docker /root/.ssh/id_ed25519
RUN chmod 700 /root/.ssh/id_ed25519
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

RUN git clone git@github.com:andrewmilson/ministark.git
RUN git clone git@github.com:andrewmilson/sandstorm-mirror.git
RUN cd sandstorm-mirror && cargo +nightly build -r -F parallel,asm

RUN git clone git@github.com:ZeroSync/sha256_cairo_goldilocks.git
RUN git clone git@github.com:ZeroSync/ZeroSync.git
RUN cd zerosync && git checkout integrate_sandstorm

COPY prove_sha256_stark_prime.sh .
RUN chmod +x prove_sha256_stark_prime.sh

# RUN ./prove_sha256_stark_prime.sh
