#!/bin/sh
set -e

echo "[ffmpeg] stabilizing DJI H264 bitstream (recording enabled)..."

mkdir -p /opt/data/recordings

while true; do
	ffmpeg \
		-hide_banner \
		-loglevel warning \
		-fflags +discardcorrupt+genpts+igndts \
		-flags low_delay \
		-err_detect ignore_err+careful \
		-use_wallclock_as_timestamps 1 \
		-analyzeduration 1000000 \
		-probesize 1000000 \
		-max_delay 500000 \
		-i rtmp://rtmp/drone \
		-vsync 1 \
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
		-g 30 \
		-keyint_min 30 \
		-sc_threshold 0 \
		-x264-params "intra-refresh=1:rc-lookahead=0" \
		-f tee "[f=flv]rtmp://rtmp/ffmpeg|[f=mp4]/opt/data/recordings/output.mp4"

	echo "[ffmpeg] restart..."
	sleep 1
done
