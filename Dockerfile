# cd /home/ilham/Documents/python/alpin_opencv_python/alpine-python-opencv-copy/
# docker build --network host -t ilham/alpine-py-cv:0.1 -f Dockerfile .
# docker run -it --network host -v /home/ilham/Documents/docker-mount:/home ilham/alpine-py-cv:0.1
ARG DEVEL_IMAGE
FROM ${DEVEL_IMAGE} as build-env
FROM alpine:3.10

COPY --from=build-env /usr/lib/libpython* /usr/lib/
RUN echo "http://dl-8.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN echo "**** install Python ****" && \
    apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

RUN mkdir -p /usr/local && \
    mkdir -p /usr/local/lib64 \
    mkdir -p /usr/local/include \
    mkdir -p /usr/local/share \
    mkdir -p /usr/local/bin \
    mkdir -p /usr/local/lib \
    mkdir -p /usr/share 

COPY --from=build-env /usr/local/include /usr/local/include
COPY --from=build-env /usr/local/bin /usr/local/bin
COPY --from=build-env /usr/local/lib /usr/local/lib
COPY --from=build-env /usr/local/lib64 /usr/local/lib64
COPY --from=build-env /usr/lib/python3.7 /usr/lib/python3.7
RUN rm -r /usr/share

COPY --from=build-env /usr/lib/libpython3.7m.so /usr/lib/
COPY --from=build-env /usr/lib/libpython3.7m.so.1.0 /usr/lib/
COPY --from=build-env /usr/lib/libpython3.so /usr/lib/

RUN apk --no-cache --update-cache add \
     openblas gtk+3.0 gst-plugins-base libdc1394 \
     tiff libwebp jasper libstdc++