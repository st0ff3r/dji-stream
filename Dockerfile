FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    ca-certificates \
    libpcre3 \
    libpcre3-dev \
    zlib1g-dev \
    libssl-dev \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Build nginx + RTMP module
RUN mkdir -p /tmp/build && cd /tmp/build && \
    wget http://nginx.org/download/nginx-1.25.3.tar.gz && \
    tar -xzf nginx-1.25.3.tar.gz && \
    git clone https://github.com/arut/nginx-rtmp-module.git && \
    cd nginx-1.25.3 && \
    ./configure \
        --with-http_ssl_module \
        --add-module=../nginx-rtmp-module \
        --prefix=/etc/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/dev/stdout \
        --http-log-path=/dev/stdout \
        --with-threads \
        --with-file-aio && \
    make -j$(nproc) && make install

RUN mkdir -p /opt/data/hls

EXPOSE 1935 80

CMD ["/etc/nginx/sbin/nginx", "-g", "daemon off;"]