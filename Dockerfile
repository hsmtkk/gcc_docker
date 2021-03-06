FROM ubuntu:20.04 AS builder

ADD vendor/gcc-10.2.0.tar.xz /usr/local/src

RUN apt-get -y update \
 && apt-get -y --no-install-recommends install curl gcc g++ make \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/src/gcc-10.2.0

RUN ./contrib/download_prerequisites \
 && mkdir /usr/local/src/objdir

WORKDIR /usr/local/src/objdir

RUN ../gcc-10.2.0/configure \
 --disable-multilib \
 --enable-languages=c,c++ \
 --prefix=/opt

RUN make -j8

RUN make install

FROM ubuntu:20.04

COPY --from=builder /opt /opt

