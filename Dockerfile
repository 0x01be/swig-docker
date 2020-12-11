FROM alpine:3.12.2 as build

ENV SWIG_VERSION=3.0.12

RUN apk add --no-cache --virtual swig-build-dependencies \
    git \
    build-base \
    autoconf \
    automake \
    pcre-dev \
    byacc

RUN git clone --depth 1 --branch v$SWIG_VERSION https://github.com/swig/swig.git /swig

WORKDIR /swig
RUN ./autogen.sh
RUN ./configure --prefix=/opt/swig
RUN make -j$(nbproc)
RUN make install

FROM alpine:3.12.2

RUN apk add --no-cache --virtual swig-runtime-dependencies \
    libstdc++ \
    libpcrecpp

COPY --from=build /opt/swig/ /opt/swig/

ENV SWIG_DIR=/opt/swig/share/swig/${SWIG_VERSION}/ \
    SWIG_EXECUTABLE=/opt/swig/bin/swig \
    PATH=${PATH}:/opt/swig/bin/

