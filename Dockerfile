FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        clang-14 \
        cmake \
        graphviz \
        llvm-14 \
        llvm-14-dev && \
    rm -rf /var/lib/apt/lists/*

ENV CLANG=clang-14
ENV OPT=opt-14
ENV BUILD_DIR=build-docker

WORKDIR /workspace

CMD ["bash", "./run_all.sh"]
