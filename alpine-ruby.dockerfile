FROM alpine
RUN apk update \
  && apk add --virtual base build-base curl git autoconf bison bash vim patch\
  && apk add --virtual ruby-deps libffi zlib zlib-dev openssl\
  && echo 'PATH=$PATH:$HOME/.rbenv/bin' > ~/.bash_profile\
  && curl -O http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p648.tar.gz\
  && tar xvfz ruby-2.0.0-p648.tar.gz\
  && cd ruby-2.0.0-p648\
  && pwd \
  && curl -O https://gist.githubusercontent.com/mayok/a0f2e6883c2e1d9bb315/raw/04a4b615b1ddbc5297e0e2d59153df008246f300/configure.in.patch \
  -O https://gist.githubusercontent.com/mayok/a0f2e6883c2e1d9bb315/raw/04a4b615b1ddbc5297e0e2d59153df008246f300/io.c.patch \
  -O https://gist.githubusercontent.com/mayok/a0f2e6883c2e1d9bb315/raw/04a4b615b1ddbc5297e0e2d59153df008246f300/isinf.patch \
  -O https://gist.githubusercontent.com/mayok/a0f2e6883c2e1d9bb315/raw/04a4b615b1ddbc5297e0e2d59153df008246f300/isnan.patch \
  && patch -u configure.in < configure.in.patch \
  && patch -u io.c < io.c.patch\
  && patch -u missing/isinf.c < isinf.patch\
  && patch -u missing/isnan.c < isnan.patch \
  && ./configure --enable-shared --disable-rpath --enable-pthread --without-tk \
  && make \
  && make install