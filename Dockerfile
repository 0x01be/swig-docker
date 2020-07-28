FROM alpine:3.12.0 as builder

ENV SWIG_VERSION v3.0.12

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

RUN git clone --depth 1 --branch $SWIG_VERSION https://github.com/swig/swig.git /swig

WORKDIR /swig
RUN ./autogen.sh
RUN ./configure --prefix=/opt/swig
RUN make -j$(nbproc)
RUN make install

FROM alpine:3.12.0

RUN apk add --no-cache --virtual runtime-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    libstdc++ \
    libpcrecpp

COPY --from=builder /opt/swig/ /opt/swig/

ENV SWIG_DIR /opt/swig/share/swig/4.1.0/
ENV SWIG_EXECUTABLE /opt/swig/bin/swig
ENV PATH $PATH:/opt/swig/bin/

