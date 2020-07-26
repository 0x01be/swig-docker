FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    git \
    build-base \
    autoconf \
    automake \
    pcre-dev \
    byacc

RUN git clone --depth 1 https://github.com/swig/swig.git /swig

WORKDIR /swig
RUN ./autogen.sh
RUN ./configure --prefix=/opt/swig
RUN make -j$(nbproc)
RUN make install

FROM alpine:3.12.0

COPY --from=builder /opt/swig/ /opt/swig/

ENV PATH $PATH:/opt/swig/bin/

