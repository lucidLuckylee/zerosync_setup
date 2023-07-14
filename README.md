# ZeroSync Docker Setup
This repository includes information and scripts for running ZeroSync related benchmarks and to set up a development environment.

## Prerequisites
Before building the docker image you need to copy a github ssh key of an account that has access to the sandstorm-mirror repository or switch it out with the public sandstorm repository at https://github.com/andrewmilson/sandstorm (and remove/adjust the scripts).
```
    # A command like this should usually copy your ssh key
    cp ~/.ssh/ed_25519 .
```
WARNING: The image will be built using your PRIVATE SSH KEY. Giving away the image is equivalent to giving out your PRIVATE KEY! You may want to generate a new one for this purpose only and temporarily add it to your GitHub account.

## Usage
```
    # Build the docker image
    docker build --tag "zerosync" .

    # Start the container with shell access
    docker start -it --name="zerosync" zerosync bash

    # If the script execution is removed from the built process you may
    # run prove_sha256_stark_prime.sh to generate a proof
    cd home
    chmod +x prove_sha256_stark_prime.sh
    ./prove_sha256_stark_prime.sh
```

