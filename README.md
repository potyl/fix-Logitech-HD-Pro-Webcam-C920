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
