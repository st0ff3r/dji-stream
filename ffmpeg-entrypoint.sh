#!/bin/sh
set -e

echo "[ffmpeg] stabilizing DJI H264 bitstream (720p optimized)..."

while true; do
	ffmpeg \
		-hide_banner \
		-loglevel warning \
		-fflags +discardcorrupt+genpts+nobuffer \
		-analyzeduration 1000000 \
		-probesize 1000000 \
		-err_detect ignore_err \
		-i rtmp://rtmp/drone \
		-map 0:v:0 \
		-an \
		-c:v libx264 \
		-preset superfast \
		-tune zerolatency \
		-pix_fmt yuv420p \
		-vf "scale=1280:720:flags=fast_bilinear" \
		-r 30 \
		-b:v 1800k \
		-maxrate 1800k \
		-bufsize 3600k \
		-g 60 \
		-keyint_min 60 \
		-sc_threshold 0 \
		-f flv rtmp://rtmp/ffmpeg

	echo "[ffmpeg] restart..."
	sleep 1
done