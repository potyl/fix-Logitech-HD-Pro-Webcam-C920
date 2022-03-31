#!/usr/bin/env bash

set -eou pipefail

function get_video_device_by_name {
    if [[ $# == 0 ]]; then
        echo "${FUNCNAME[0]}: device_name"
        exit 1
    fi
    local webcam_name="$1"
    device="$(v4l2-ctl --list-devices | grep -A1 "$webcam_name" | tail -n1 | sed -E 's/^\s+//')"

    if [[ -n "$device" ]]; then
        echo "$device"
        return 0
    fi

    return 1
}

function get_device {
    if [[ $# == 0 ]]; then
        echo "${FUNCNAME[0]}: device"
        exit 1
    fi
    local device="$1"

    if [[ -e "$device" ]]; then
        echo "$device"
        return 0
    fi

    return 1
}

webcam_name='HD Pro Webcam C920'

# Get the video device of the logitech camera
video_device="$(get_device /dev/web-c920 || get_video_device_by_name "$webcam_name" || get_video_device_by_name "Video Capture" || get_device /dev/vide0)"
if [[ -z "$video_device" ]]; then
    echo "Failed to find video device for $webcam_name"
    exit 1 
fi

webcam_name="$(v4l2-ctl --device "$video_device" --info | grep -E '^\s+Card type\s+:' | sed -E 's/^.*?:\s+//')"
echo "Found video device: $video_device for $webcam_name"

v4l2-ctl --device "$video_device" --set-ctrl=focus_auto=0

exit 0
