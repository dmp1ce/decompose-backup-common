FROM alpine
MAINTAINER David Parrish <daveparrish@tutanota.com>

# Install decompose
RUN mkdir -p /opt/decompose && \
apk add --update git perl bash tar && \
git clone --recursive https://github.com/dmp1ce/decompose.git /opt/decompose && \
ln -s /opt/decompose/decompose /usr/local/bin && \
rm -rf /var/cache/apk/*

ADD . /app
