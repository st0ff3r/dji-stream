#!/bin/sh
set -e

echo "[ffmpeg] stabilizing DJI H264 bitstream..."

while true; do
  ffmpeg \
    -hide_banner \
    -loglevel warning \
    -fflags +discardcorrupt+genpts \
    -err_detect ignore_err \
    -analyzeduration 5000000 \
    -probesize 5000000 \
    -i rtmp://rtmp/live/drone \
    -map 0:v:0 \
    -an \
    -c:v libx264 \
    -preset veryfast \
    -tune zerolatency \
    -pix_fmt yuv420p \
    -vf "format=yuv420p,scale=1280:720" \
    -x264-params "nal-hrd=cbr:force-cfr=1:keyint=60:min-keyint=60:scenecut=0" \
    -b:v 2500k \
    -maxrate 2500k \
    -bufsize 5000k \
    -f flv rtmp://rtmp/clean/stream

  echo "[ffmpeg] restart..."
  sleep 2
done