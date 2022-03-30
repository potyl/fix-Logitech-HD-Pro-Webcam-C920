# Fix the Logitech HD Pro Webcam C920

This repository contains tweaks to the autofocus of the Logitech HD Pro Webcam C920 for Linux.

The webcam is pretty good and works out of the box, but it tends to go out of focus randomly.
This is not a deal breaker and usually bringing an object close to the lense (your finger)
will refocus the camera.

Although it should be possible to disable the autofocus so that the camera doesn't change the
focus.

This is inspired by the video [How to disable autofocus on webcam in Linux | Logitech C920](https://youtu.be/7SZBQ5bqaWU).

This repo provides a script and a systemd service for tweaking the camera at startup.

## Installation

Clone the repo and run:

```bash
make install
```

## Uninstallation

```bash
make uninstall
```

## Troubleshooting

You can see the status of the service with:

```bash
make status
```

And you can get the logs with:

```bash
make logs
```

## How it works

This package installs an `udev` rule that's used for detecting when the webcam is plugged and to run a script to alter the configuration via a `systemd` service.

The script will in turn change the webcam settings so that the focus works better.
These changes are not permanent and need to be reapplied at each reboot or when the camera is plugged in.
The `udev` rule is in charge of detecting when new hardware is plugged in and to apply the configuration changes.

### udev rule

The `udev` rule is installed under `/etc/udev/rules.d/99-fix-Logitech-HD-Pro-Webcam-C920.rules` and contains:

```udev
# Detect a "Logitech, Inc. HD Pro Webcam C920"
ACTION=="add", \
  SUBSYSTEM=="video4linux", \
  ATTRS{idVendor}=="046d", \
  ATTRS{idProduct}=="082d", \
  ENV{ID_V4L_CAPABILITIES}==":capture:", \
  SYMLINK+="web-c920", \
  TAG+="systemd", \
  MODE="0666", \
  ENV{SYSTEMD_WANTS}="fix-Logitech-HD-Pro-Webcam-C920.service"
```

This rules matches the equivalent of of `lsusb`:

```output
Bus 005 Device 002: ID 046d:082d Logitech, Inc. HD Pro Webcam C920
```

**NOTE**: Your `Bus` and `Device` numbers will most likely not match. What needs to match is the `ID`: `046d:082d`.

The `udev` rule will create a symlink named `/dev/web-c920` that will point to the webcam's main device entry (e.g. `/dev/video0`).
It will then invoke the `systemd` service `fix-Logitech-HD-Pro-Webcam-C920.service` to apply the configuration changes.

### systemd service

This service runs a simple shell script that uses `v4l2-ctl` for reconfiguring some parameters of the webcam.

The `systemd` service will then run the equivalent of:

```bash
v4l2-ctl --device /dev/web-c920 --set-ctrl=focus_auto=0
```
