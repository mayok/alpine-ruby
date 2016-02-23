FROM alpine
RUN apk update \
  && apk add --virtual base build-base curl git autoconf bison bash vim patch\
  && apk add --virtual ruby-deps libffi zlib zlib-dev openssl\
  && curl -O http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p648.tar.gz\
  && tar xvfz ruby-2.0.0-p648.tar.gz\
  && cd ruby-2.0.0-p648\
  && curl -O https://gist.githubusercontent.com/mayok/a0f2e6883c2e1d9bb315/raw/04a4b615b1ddbc5297e0e2d59153df008246f300/configure.in.patch \
  -O https://gist.githubusercontent.com/mayok/a0f2e6883c2e1d9bb315/raw/04a4b615b1ddbc5297e0e2d59153df008246f300/io.c.patch \
  -O https://gist.githubusercontent.com/mayok/a0f2e6883c2e1d9bb315/raw/04a4b615b1ddbc5297e0e2d59153df008246f300/isinf.patch \
  -O https://gist.githubusercontent.com/mayok/a0f2e6883c2e1d9bb315/raw/04a4b615b1ddbc5297e0e2d59153df008246f300/isnan.patch \
  -O https://gist.githubusercontent.com/mayok/a0f2e6883c2e1d9bb315/raw/9a6a76d4a32631a0da688910e566bfd1917a7607/no_gems.patch \
  && patch -u configure.in < configure.in.patch \
  && patch -u io.c < io.c.patch\
  && patch -u missing/isinf.c < isinf.patch\
  && patch -u missing/isnan.c < isnan.patch \
  && patch -u tool/rbinstall.rb < no_gems.patch \
  && rm -r bin/rake lib/rake lib/rake.rb man/rake.1 bin/gem \
  && ./configure --enable-shared --disable-rpath --enable-pthread --without-tk \
  && make \
  && rm -rf ext/json \
  && make install \

# Remove installed rubygems copy
# rm -r /usr/local/lib/ruby/gems/2.0.0/rdoc

  && cd .. \
  && rm -r ruby-2.0.0-p648 \
  && rm ruby-2.0.0-p648.tar.gz

RUN git clone https://github.com/rubygems/rubygems.git \
  && cd rubygems \
  && ruby setup.rb
