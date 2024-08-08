FROM debian:12.2-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# build emulator libraries
RUN apt-get update && \
    apt-get install -yqq \
      tzdata build-essential cmake clang openssl \
      libssl-dev zlib1g-dev gperf wget git curl \
      libreadline-dev ccache libmicrohttpd-dev ninja-build pkg-config \
      libsecp256k1-dev libsodium-dev liblz4-dev

RUN git clone https://github.com/ton-blockchain/ton.git
RUN cd /ton && git submodule update --init --recursive

RUN mkdir build && (cd build && cmake ../ton -DCMAKE_BUILD_TYPE=Release && cmake --build . --target emulator -- -j 8)

RUN mkdir /output
RUN cp build/emulator/libemulator.so /output
