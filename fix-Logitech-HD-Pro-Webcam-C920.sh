#!/usr/bin/env bash

set -eou pipefail

function get_video_device() {
    if [[ $# == 0 ]]; then
        echo "${FUNCNAME[0]}: device_name"
        exit 1
    fi
    local webcam_name="$1"
    v4l2-ctl --list-devices | grep -A1 "$webcam_name" | tail -n1 | sed -E 's/^\s+//'
}

webcam_name='HD Pro Webcam C920'

# Get the video device of the logitech camera
video_device=$(get_video_device "$webcam_name" || get_video_device "Video Capture" || echo /dev/video0)

if [[ -z "$video_device" ]]; then
    echo "Failed to find video device for $webcam_name"
    exit 1 
fi

echo "Found video device: $video_device for $webcam_name"

v4l2-ctl -d "$video_device" --set-ctrl=focus_auto=0

exit 0
