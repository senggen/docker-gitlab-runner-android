#!/bin/bash
emulator -avd testAVD -wipe-data -noaudio -no-window -gpu off -verbose -qemu -vnc :2 -skin 1440x2560 &
gitlab-runner
while true;do echo hello docker;sleep 1;done
