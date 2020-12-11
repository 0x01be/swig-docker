FROM alpine:3.12.2 as build

ENV SWIG_VERSION=4.1.0
WORKDIR /swig

RUN apk add --no-cache --virtual swig-build-dependencies \
    git \
    build-base \
    autoconf \
    automake \
    pcre-dev \
    byacc &&\
    git clone --depth 1 https://github.com/swig/swig.git /swig &&\
    ./autogen.sh &&\
    ./configure --prefix=/opt/swig &&\
     make -j$(nbproc)
RUN make install

FROM alpine:3.12.2

RUN apk add --no-cache --virtual swig-runtime-dependencies \
    libstdc++ \
    libpcrecpp

COPY --from=build /opt/swig/ /opt/swig/

ENV SWIG_DIR=/opt/swig/share/swig/${SWIG_VERSION}/ \
    SWIG_EXECUTABLE=/opt/swig/bin/swig \
    PATH=${PATH}:/opt/swig/bin/

