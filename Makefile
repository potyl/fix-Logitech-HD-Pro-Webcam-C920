SHELL := bash

WEBCAM_DEVICE   = /dev/video0

COLOR_START     = \e[91m\e[1m
COLOR_END       = \e[0m
SAY             = @printf "$(COLOR_START)%s\n$(COLOR_END)"

.PHONY: info
info:
	$(SAY) "Video device"
	@echo "WEBCAM_DEVICE:  $(WEBCAM_DEVICE)"
	@echo

	$(SAY) "Video controls"
	@v4l2-ctl --device "$(WEBCAM_DEVICE)" --get-ctrl focus_auto --get-ctrl exposure_auto


.PHONY: setup
setup:
	sudo apt update && sudo apt install v4l-utils


.PHONY: run
run:
	sudo ./fix-Logitech-HD-Pro-Webcam-C920.sh


.PHONY: list-ctrls
list-ctrls:
	v4l2-ctl --device "$(WEBCAM_DEVICE)" --list-ctrls


.PHONY: status
status:
	systemctl status fix-Logitech-HD-Pro-Webcam-C920.service || true


.PHONY: logs
logs:
	journalctl -xe -u fix-Logitech-HD-Pro-Webcam-C920.service


.PHONY: install
install:
	$(SAY) "Installing script"
	sudo install -m 0755 -o root -g root fix-Logitech-HD-Pro-Webcam-C920.sh /usr/local/bin/

	$(SAY) "Installing systemd service"
	sudo install -m 0644 -o root -g root fix-Logitech-HD-Pro-Webcam-C920.service /etc/systemd/system/

	$(SAY) "Enabling service"
	sudo systemctl daemon-reload
	sudo systemctl enable fix-Logitech-HD-Pro-Webcam-C920.service 


.PHONY: uninstall
uninstall:
	$(SAY) "Disabling service"
	sudo systemctl disable fix-Logitech-HD-Pro-Webcam-C920.service 
	sudo systemctl daemon-reload

	$(SAY) "Uninstalling script"
	sudo rm -f /usr/local/bin/fix-Logitech-HD-Pro-Webcam-C920.sh

	$(SAY) "Uninstalling systemd service"
	sudo rm -f /etc/systemd/system/fix-Logitech-HD-Pro-Webcam-C920.service
