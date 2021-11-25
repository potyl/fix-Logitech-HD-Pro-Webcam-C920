#!/usr/bin/env bash

set -eou pipefail

webcam_name='HD Pro Webcam C920'

# Get the video device of the logitech camera
video_device=$(v4l2-ctl --list-devices | grep -A1 "$webcam_name" | tail -n1 | sed -E 's/^\s+//')

if [[ -z "$video_device" ]]; then
    echo "Failed to find video device for $webcam_name"
    exit 1 
fi

echo "Found video device: $video_device for $webcam_name"

v4l2-ctl -d "$video_device" --set-ctrl=focus_auto=0
v4l2-ctl -d "$video_device" --set-ctrl=exposure_auto=1

exit 0
