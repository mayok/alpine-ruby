FROM alpine
COPY ["io.c.patch", "isnan.c.patch", "isinf.c.patch", "/tmp/"]
RUN apk update \
  && apk add --virtual base build-base curl git autoconf bison bash vim patch \
  && apk add --virtual ruby-deps libffi zlib zlib-dev openssl-dev

RUN curl -O http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p648.tar.gz\
  && tar xfz ruby-2.0.0-p648.tar.gz\
  && cd ruby-2.0.0-p648\
  && patch io.c < /tmp/io.c.patch \
  && patch missing/isinf.c < /tmp/isinf.c.patch \
  && patch missing/isnan.c < /tmp/isnan.c.patch

RUN cd ruby-2.0.0-p648 \
  && ./configure --enable-shared --disable-rpath --enable-pthread --with-out-ext="tk" --enable-option-checking=no \
  && make \
  && make install

RUN \
  rm -r ruby-2.0.0-p648 \
  && rm ruby-2.0.0-p648.tar.gz

ENV PATH $PATH:/usr/local/bin

RUN gem install bundler
